# System Tray Linux Broken (Cross-Desktop App Lifecycle & Dock Manager)

A cross-desktop utility for Linux that automates the lifecycle of application shortcuts and dock/panel icons. It is designed for applications that lack native or functional tray integration, persistent pinning, or proper lifecycle management (such as Electron clients, AppImages, and packaged web apps like Nerimity, Discord, or Spotify).

When you launch the app, the utility dynamically injects a shortcut into your active desktop environment's panel or dock. As soon as the application process exits, the shortcut is cleanly removed, keeping your workspace uncluttered.

---

## How It Works

Different Linux desktop environments handle panels, docks, and launchers through entirely different APIs and configuration structures. This project uses a **multi-backend architecture** that detects your active Desktop Environment (`$XDG_CURRENT_DESKTOP`) and applies the appropriate method:

1. **KDE Plasma:** Interacts with the Plasma QML engine and D-Bus (`qdbus6`) to inject and position panel icon widgets relative to the System Tray.
2. **GNOME Shell:** Interacts with extension schemas (like *Dash to Dock*) or `gsettings` to manage favorite application pinned lists dynamically.
3. **XFCE / Generic Docks:** Manages panel launcher configurations or standalone dock items (such as Plank) to handle runtime visibility.
4. **Transparent Wrapper:** Generates a local `.desktop` wrapper in `~/.local/share/applications/` pointing to a background monitor script (`-launcher.sh`) that tracks the application's PID.

---

## Supported Environments & Backends

* **KDE Plasma (5 & 6):** Fully supported via D-Bus script evaluation.
* **GNOME Shell:** Supported via extension settings integration.
* **XFCE & Generic Docks:** Supported via standard desktop shortcut manipulation and process monitoring.

---

## Prerequisites

* **Environment:** Linux with a supported Desktop Environment / Window Manager.
* **Tools:** `bash`, `pgrep` (`procps-ng`), `desktop-file-utils` (`update-desktop-database`), and environment-specific tools (e.g., `qdbus6` for KDE).

---

## Installation & Usage

1. **Clone or download the repository and make the script executable:**
   ```bash
   chmod +x "system-tray-broken.sh"

```

2. **Run the interactive setup wizard:**
```bash
./"system-tray-broken.sh"

```


3. **Follow the interactive prompts:**
* Enter the **exact app name** (e.g., `nerimity`).
* Enter the **full path to the executable or AppImage** (e.g., `/opt/Nerimity/nerimity-desktop`).
* Choose your preferred positioning or dock behavior based on your detected desktop environment.


4. **All set!** Launch your application normally from your system menu. The icon will appear while running and disappear automatically upon exit.

---

## Generated File Structure

* `~/.local/bin/<app>-launcher.sh` — The background wrapper script that handles the runtime lifecycle, process monitoring (PID), and dynamic widget/icon insertion/removal.
* `~/.local/share/applications/<app>.desktop` — The updated local desktop entry routing application launches through your custom lifecycle manager.

---

## Credits

* **Conception, architecture, testing, and multi-DE vision:** [kayronn](https://www.google.com/search?q=https://github.com/kayronn)
* **Code development, D-Bus/QML engine mapping, and cross-desktop logic:** **Gemini** (Google AI)

```

```
