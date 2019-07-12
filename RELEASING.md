1. Make sure you have both clones of
   [swiftbrew/Swiftbrew](https://github.com/swiftbrew/Swiftbrew) and
   [swiftbrew/homebrew-tap](https://github.com/swiftbrew/homebrew-tap) under a
   same parent directory, for example:

    ```
    swiftbrew-org
    ├── Swiftbrew
    └── homebrew-tap
    ```

2. Make sure you have [hub](https://hub.github.com) installed and configured.
3. Run `make release version=x.y.z` to release a new version `x.y.z`.
