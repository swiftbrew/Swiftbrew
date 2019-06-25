import Colorizer

func printProcessingInfo(_ message: String) {
    print("==> ".foreground.Cyan + message.style.Bold)
}

func printInfo(_ message: String) {
    print(message)
}

func printWarning(_ message: String) {
    print("Warning: ".foreground.Yellow + message)
}

func printError(_ message: String) {
    print("Error: ".foreground.Red + message)
}
