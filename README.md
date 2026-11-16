# System Tray Linux Broken (Cross-Desktop App Lifecycle & Dock Manager)

A cross-desktop utility for Linux that automates the lifecycle of application shortcuts and dock/panel icons. It is designed for applications that lack native or functional tray integration, persistent pinning, or proper lifecycle management (such as Electron clients, AppImages, and packaged web apps like Nerimity, Discord, or Spotify).

When you launch the app, the utility dynamically injects a shortcut into your active desktop environment's panel or dock. As soon as the application process exits, the shortcut is cleanly removed, keeping your workspace uncluttered.

---

## How It Works

Different Linux desktop environments handle panels, docks, and launchers through entirely different APIs and configuration structures. Therefore, the project provides dedicated script versions for each environment to handle injection, positioning, and cleanup natively:

1. **KDE Plasma:** Interacts with the Plasma QML engine and D-Bus (`qdbus6`) to inject and position panel icon widgets relative to the System Tray.
2. **GNOME Shell / XFCE / Other DEs:** Interacts with respective panel configurations or extension schemas.
3. **Transparent Wrapper:** Generates a local `.desktop` wrapper in `~/.local/share/applications/` pointing to a background monitor script (`-launcher.sh`) that tracks the application's PID.

---

## Supported Environments & Backends

* **KDE Plasma (5 & 6):** Fully supported (`system-tray-broken-kde.sh`).
* **GNOME Shell / XFCE / Other DEs:** If your Desktop Environment is not listed, **it is likely under development or not yet supported.** Feel free to open an issue or contribute!

---

## Prerequisites

* **Environment:** Linux with a supported Desktop Environment / Window Manager.
* **Tools:** `bash`, `pgrep` (`procps-ng`), `desktop-file-utils` (`update-desktop-database`), and environment-specific tools (e.g., `qdbus6` for KDE).

---

## Installation & Usage

1. **Download the `.sh` script version corresponding to your Desktop Environment.**
2. **Open your terminal.**
3. **Drag and drop the downloaded `.sh` file directly into the terminal window and press `Enter`.**
4. Follow the interactive prompts in your terminal to enter the app name, executable path, and preferred position.
5. All set! Launch your application normally from your system menu. The icon will appear while running and disappear automatically upon exit.

---

## Generated File Structure

* `~/.local/bin/<app>-launcher.sh` — The background wrapper script that handles the runtime lifecycle, process monitoring (PID), and dynamic widget/icon insertion/removal.
* `~/.local/share/applications/<app>.desktop` — The updated local desktop entry routing application launches through your custom lifecycle manager.

---

## Credits

* **Conception, architecture, testing, and multi-DE vision:** [kayronn](https://github.com/kayronn)
* **Code development, D-Bus/QML engine mapping, and cross-desktop logic:** **Gemini** (Google AI)
