import Foundation
import Guaka
import Just
import SwiftbrewCore

var uninstallCommand = Command(
    usage: "uninstall",
    configuration: configuration,
    run: run
)

private func configuration(command: Command) {
    command.shortMessage = "Uninstall a package"
    command.longMessage = """
    Uninstall a Swift command line tool package by name:

      swift brew uninstall <package-name>
    """
    command.example = """
      swift brew uninstall xcbeautify
    """
}

private func run(flags: Flags, args: [String]) {
    guard let package = args.first else {
        // Print help
        return
    }

    try? SwiftbrewCore.uninstall(name: package)
}
