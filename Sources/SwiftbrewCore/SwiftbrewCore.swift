import Colorizer
import Foundation
import Just
import MintKit
import Run
import Utility

#if DEBUG
private let baseURL = "http://localhost:8081/bottles"
private let buildTriggerURL = "http://localhost:8082/bottles"
#else
private let baseURL = "https://dl.bintray.com/swiftbrew/bottles"
private let buildTriggerURL = "https://swiftbrew-server.herokuapp.com/bottles"
#endif

private let prefix = "/usr/local"
private let binDirectory = "\(prefix)/bin"

private let swiftbrewHomePath = "\(prefix)/lib/swiftbrew"
private let cellarPath = "\(swiftbrewHomePath)/cellar"
private let cachesPath = "\(swiftbrewHomePath)/caches"

private let maxTryCount = 20
private let waitingInterval: UInt32 = 30

public func install(package: String) throws {
    let packageRef = PackageReference(package: package)

    if packageRef.version.isEmpty {
        try resolvePackageVersion(packageRef)
    }

    let repoPath = packageRef.repoPath
    let packageVersion = packageRef.version

    printProcessingInfo("Installing \(packageRef.namedVersion)")

    // We only have macOS Mojave for now, but that might change soon
    let cachedBottleFilename = repoPath + "-\(packageVersion).\(currentPlatformName()).tar.xz"
    let bottleURL = URL(string: baseURL)!.appendingPathComponent(cachedBottleFilename)

    printProcessingInfo("Downloading \(bottleURL)")

    let cachedBottlePath = "\(cachesPath)/\(cachedBottleFilename)"

    var bottleData: Data? = nil
    var tryCount = 0

    repeat {
        let result = Just.get(bottleURL)
        if result.ok, let data = result.content {
            bottleData = data
            break
        }

        if tryCount == 0 {
            printInfo("Bottle not yet available. Sent a build request to build workers.")
            let res = Just.post(
                buildTriggerURL,
                data: [
                    "name": packageRef.repoPath,
                    "gitURL": packageRef.gitPath,
                    "version": packageRef.version
                ]
            )
            if let error = res.error {
                printError(error.localizedDescription)
            }
        }

        printProcessingInfo("Waiting for bottle to be available...")
        tryCount += 1

        if tryCount == maxTryCount {
            printInfo("Bottle still not available after \(tryCount * Int(waitingInterval) / 60) minutes wait. Try again next time. Bye!")
            exit(1)
        }

        sleep(waitingInterval)
    } while tryCount < maxTryCount

    let makeCachesDir = run("mkdir -p \(cachesPath)")
    guard makeCachesDir.exitStatus == 0 else {
        printError(makeCachesDir.stderr.foreground.Red)
        exit(1)
    }

    guard FileManager.default.createFile(
        atPath: cachedBottlePath,
        contents: bottleData,
        attributes: nil)
    else {
        printError("==> Error writing to path \(cachedBottlePath)".foreground.Red)
        exit(1)
    }

    printProcessingInfo("Pouring \(cachedBottleFilename)")

    let makeCellarDir = run("mkdir -p \(cellarPath)")
    guard makeCellarDir.exitStatus == 0 else {
        printError(makeCellarDir.stderr)
        exit(1)
    }

    let tar = run("tar xf \(cachesPath)/\(cachedBottleFilename) -C \(cellarPath)")
    guard tar.exitStatus == 0 else {
        printError(tar.stderr)
        exit(1)
    }

    let installPath = "\(cellarPath)/\(repoPath)/build/\(packageVersion)"

    try linkExecutables(installPath: installPath)

    printInfo("🍺  \(installPath)")
}

private func linkExecutables(installPath: String) throws {
    let ls = run("/bin/ls \(installPath)")
    guard ls.exitStatus == 0 else {
        printError(ls.stderr)
        exit(1)
    }

    let executables = ls
        .stdout
        .split(separator: "\n")
        .map(String.init)

    for executable in executables {
        let executablePath = "\(installPath)/\(executable)"
        let symlinkPath = "\(binDirectory)/\(executable)"
        let ln = run("/bin/ln -sf \(executablePath) \(symlinkPath)")

        guard ln.exitStatus == 0 else {
            printError(ln.stderr)
            exit(1)
        }
    }
}

private func resolvePackageVersion(_ package: PackageReference) throws {
    // We don't have a specific version, let's get the latest tag
    printProcessingInfo("Finding latest version of \(package.name)")

    let tagOutput = run("git ls-remote --tags --refs \(package.gitPath)")
    let tagReferences = tagOutput.stdout

    if tagReferences.isEmpty {
        let headOutput = run("git ls-remote --heads \(package.gitPath)")
        let headReferences = headOutput.stdout
        package.version = headReferences.split(separator: "\t").map(String.init).first!
    } else {
        let tags = tagReferences.split(separator: "\n").map { String($0.split(separator: "\t").last!.split(separator: "/").last!) }
        let versions = Git.convertTagsToVersionMap(tags)
        if let latestVersion = versions.keys.sorted().last, let tag = versions[latestVersion] {
            package.version = tag
        } else {
            package.version = "master"
        }
    }

    printInfo("Resolved latest version of \(package.name) to \(package.version)")
}
