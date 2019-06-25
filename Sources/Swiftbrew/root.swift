import Guaka
import SwiftbrewCore

var rootCommand = Command(
    usage: "swift-brew",
    configuration: configuration,
    run: nil
)

private func configuration(command: Command) {
    command.add(flags: [
        .init(shortName: "v",
              longName: "version",
              value: false,
              description: "Print the version",
              inheritable: true)
        ])

    command.inheritablePreRun = { flags, args in
        if let versionFlag = flags.getBool(name: "version"), versionFlag == true {
            print(SwiftbrewCore.version)
            return false
        }

        return true
    }
}

private func run(flags: Flags, args: [String]) {
}
