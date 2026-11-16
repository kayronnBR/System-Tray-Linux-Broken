# System Tray Linux Broken (KDE Plasma 6 Dynamic Widget Manager)

A Bash and D-Bus (`qdbus6`) utility built for **KDE Plasma 6** that automates the lifecycle of panel icons for applications lacking native or functional System Tray support on Linux—such as Electron clients, AppImages, or packaged web apps (e.g., Nerimity, Discord, Spotify).

When you launch the app from your application menu, the script dynamically injects a shortcut widget (`org.kde.plasma.icon`) positioned precisely next to your native **System Tray**. As soon as the application process exits, the widget is automatically removed from the panel, keeping your bar clean.

---

## How It Works

KDE Plasma 6 manages panel widgets through its QML engine and the JavaScript D-Bus API (`org.kde.PlasmaShell.evaluateScript`). This project solves key automation hurdles on Plasma 6:

1. **Root Group Discovery (`[]`):** On Plasma 6, `org.kde.plasma.icon` widgets store `url` and `localPath` directly in the root configuration group rather than `['General']`.
2. **Deterministic Physical Ordering:** Since the panel's QML visual engine renders items in the exact order they are instantiated during the session, the script preserves adjacent widget settings (System Tray and Digital Clock) and instantiates components in the precise sequence chosen (**to the left** or **to the right** of the System Tray).
3. **Transparent `.desktop` Wrapper:** The script creates a local copy of the desktop shortcut in `~/.local/share/applications/` pointing to a dedicated launcher in `~/.local/bin/`, preserving the original name, icon, and application menu integration.

---

## Prerequisites

* **Environment:** KDE Plasma 6 (Wayland or X11)
* **Tools:** `qdbus6` (typically included in `qt6-tools` or `qdbus-qt6`), `pgrep` (`procps-ng`), and `desktop-file-utils` (`update-desktop-database`).

---

## Installation & Usage

1. **Make the script executable:**
   ```bash
   chmod +x "system tray broken.sh"

```

2. **Run the interactive setup wizard:**
```bash
./"system tray broken.sh"

```


3. **Follow the interactive prompts in your terminal:**
* Enter the **exact app name** (e.g., `nerimity`).
* Enter the **full path to the executable or AppImage** (e.g., `/opt/Nerimity/nerimity-desktop`).
* Choose whether you want the icon to appear **to the left (1)** or **to the right (2)** of the System Tray.


4. **All set!** Launch the application normally from your application menu (Kickoff). The icon will appear at your configured panel position and automatically disappear when the program closes.

---

## Generated File Structure

* `~/.local/bin/<app>-launcher.sh` — The runner script responsible for injecting the widget, launching the binary, monitoring the process PID, and removing the icon upon exit.
* `~/.local/share/applications/<app>.desktop` — The updated local desktop shortcut triggering the custom launcher while keeping original metadata and icons.

---

## Credits

* **Conception, architecture, testing, and validation on KDE Plasma 6:** [kayronn](https://www.google.com/search?q=https://github.com/kayronn)
* **Code development, Plasma 6 D-Bus/QML API reverse engineering, and debugging:** **Gemini** (Google AI)

```

```
