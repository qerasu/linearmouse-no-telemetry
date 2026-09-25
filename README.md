# LinearMouse (local build)

This checkout builds an English-only macOS app without an in-app updater or external help links.

Build once with Xcode installed:

```sh
make
```

The app is written to `build/Build/Products/Release/LinearMouse.app`. Xcode may download the pinned Swift packages during this build. The app needs Accessibility permission to control mouse input.

See [ACCESSIBILITY.md](ACCESSIBILITY.md) for permission details and [Documentation/Configuration.md](Documentation/Configuration.md) for settings.

License: [MIT](LICENSE).
