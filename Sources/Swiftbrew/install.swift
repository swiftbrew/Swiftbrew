import Foundation
import Guaka
import Just
import SwiftbrewCore

var installCommand = Command(
    usage: "install",
    configuration: configuration,
    run: run
)

private func configuration(command: Command) {
    command.shortMessage = "Install a package"
    command.longMessage = """
    Install a Swift command line tool package:

      swift brew install <package-reference>

    <package-reference> can be a shorthand for a GitHub repository (Carthage/Carthage)
    or a full git URL (https://github.com/Carthage/Carthage.git), optionally followed
    by a tagged version (@x.y.z).

    Note: Swiftbrew currently only supports public repositories.
    """
    command.example = """
      swift brew install thii/xcbeautify
      swift brew install thii/xcbeautify@0.4.3
      swift brew install https://github.com/thii/xcbeautify
    """
}

private func run(flags: Flags, args: [String]) {
    guard let package = args.first else {
        // Print help
        return
    }

    try? SwiftbrewCore.install(package: package)
}
