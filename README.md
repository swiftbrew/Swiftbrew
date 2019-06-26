# Swiftbrew [![Build Status](https://travis-ci.com/swiftbrew/Swiftbrew.svg?branch=master)](https://travis-ci.com/swiftbrew/Swiftbrew)

A package manager that installs prebuilt Swift command line tool packages, or _Homebrew for Swift packages_.

## Installation
### Homebrew

```
brew install swiftbrew/tap/swiftbrew
```

### Mint

```
mint install swiftbrew/Swiftbrew
```

## Usage

```
swift brew install <package-reference>
```

Package reference can be a shorthand for a GitHub repository
(`Carthage/Carthage`) or a full git URL
(`https://github.com/Carthage/Carthage.git`), optionally followed by a tagged
version (`@x.y.z`). Swiftbrew currently only supports public repositories.

### Examples

Install the latest version of `Carthage`:

```
swift brew install Carthage/Carthage
```
or

```
swift brew install https://github.com/Carthage/Carthage
```

Install `Carthage` version 0.33.0:

```
swift brew install Carthage/Carthage@0.33.0
```

## Why create another package manager?

[Homebrew](https://brew.sh) is a popular method of distributing command line
tools on macOS. Some popular Swift command line tools are already distributed
via Homebrew. But there are some limitations:

- Distributing via Homebrew requires you to create a formula and then maintain
  that formula.
- If your package is not popular enough to be accepted into Homebrew's core
  formulae, you would have to create and maintain your own tap.
- As a package maintainer, a usual release process would be: build the
  executable, archive it into a tarball/zipball, upload it to GitHub releases,
  bump formula version. This is a cumbersome process.
- It can be tricky to install a specific version of a tool with Homebrew.

[Mint](https://github.com/yonaskolb/Mint) is a package manager that builds and
installs Swift command line tool packages. Mint is more flexible than Homebrew
as it allows installing a specific version of a package. The downside of Mint
is that it requires you to build all packages from source. This can be very
time-consuming as you start replacing most of your Ruby tools in your iOS
project with Swift packages, since bumping a tool version would require
rebuilding it from all your developers' machines.

### Introducing Swiftbrew

**Swiftbrew** saves Swift packages maintainers and users' time by caching
prebuilt Swift command line tool packages, while flexible enough to let users
install multiple versions of a package. Swiftbrew builds and caches Swift
packages on CDN servers so that they are fast to download from anywhere.
Swiftbrew bottles (prebuilt packages) are hosted on
[Bintray](http://bintray.com), the same service that hosts Homebrew bottles. If
any package is not available as a bottle, it will be built by Swiftbrew build
workers and cached after the first installation request, so that it will
available for everyone later on. Here is what an installation output looks
like:

```
$ swift brew install Carthage/Carthage

==> Finding latest version of Carthage
Resolved latest version of Carthage to 0.33.0
==> Installing Carthage 0.33.0
==> Downloading https://dl.bintray.com/swiftbrew/bottles/github.com_Carthage_Carthage-0.33.0.mojave.tar.xz
Bottle not yet available. Sent a build request to build workers.
==> Waiting for bottle to be available...
==> Pouring github.com_Carthage_Carthage-0.33.0.mojave.tar.xz
🍺  /usr/local/lib/swiftbrew/cellar/github.com_Carthage_Carthage/build/0.33.0
```

## FAQ

*What kind of packages can Swiftbrew install?*

> Swiftbrew can install any public Swift command line tool package. If your
> package can be built with `swift build` command, then it can be installed via
> Swiftbrew.

*Can I add my own package?*

> Yes, if your package's Git URL is public. Just install your package with
> Swiftbrew, a built request will be sent to Swiftbrew's build workers, then
> the bottle will be available after a few minutes.

*What platforms does Swiftbrew support?*

> We only have build workers that run macOS Mojave in the meantime. Other macOS
> versions and Linux may be added in the future upon community requests.

## License

MIT
