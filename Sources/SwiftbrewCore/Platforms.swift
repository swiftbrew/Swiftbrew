import Foundation

struct MacOS {
    let majorVersion: Int
    let minorVersion: Int

    func name() -> String {
        guard majorVersion == 10 else {
            fatalError("Unsupported macOS version")
        }

        switch minorVersion {
        case 13:
            return "high_sierra"
        case 14:
            return "mojave"
        case 15:
            // Install bottles for macOS Mojave for now until we have build workers for macOS Catalina.
            // return "catalina"
            return "mojave"
        default:
            return "macos_10.16"
        }
    }
}

func currentPlatformName() -> String {
    #if os(macOS)
    let osVersion = ProcessInfo.processInfo.operatingSystemVersion

    return MacOS(
        majorVersion: osVersion.majorVersion,
        minorVersion: osVersion.minorVersion)
        .name()
    #else
    return "x86_64_linux"
    #endif
}
