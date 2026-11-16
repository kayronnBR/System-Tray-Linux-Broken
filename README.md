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
* **GNOME Shell / XFCE / Outras DEs:** Caso a sua Interface Gráfica (DE) não apareça na lista acima, **provavelmente está em desenvolvimento ou ainda não possui suporte oficial.** Fique à vontade para abrir uma issue ou contribuir!

---

## Prerequisites

* **Environment:** Linux with a supported Desktop Environment / Window Manager.
* **Tools:** `bash`, `pgrep` (`procps-ng`), `desktop-file-utils` (`update-desktop-database`), and environment-specific tools (e.g., `qdbus6` for KDE).

---

## Installation & Usage

1. **Baixe ou acesse o repositório e baixe a versão do script (`.sh`) correspondente à sua DE.**
2. **Abra o seu terminal.**
3. **Arraste o arquivo `.sh` baixado diretamente para dentro da janela do terminal e aperte `Enter`.**
4. Siga as instruções interativas que aparecerão na tela para informar o nome do app, caminho do executável e a posição desejada.
5. Pronto! Abra o aplicativo normalmente pelo menu iniciar. O ícone aparecerá enquanto o app estiver aberto e sumirá automaticamente ao fechar.

---

## Generated File Structure

* `~/.local/bin/<app>-launcher.sh` — The background wrapper script that handles the runtime lifecycle, process monitoring (PID), and dynamic widget/icon insertion/removal.
* `~/.local/share/applications/<app>.desktop` — The updated local desktop entry routing application launches through your custom lifecycle manager.

---

## Credits

* **Conception, architecture, testing, and multi-DE vision:** [kayronn](https://github.com/kayronn)
* **Code development, D-Bus/QML engine mapping, and cross-desktop logic:** **Gemini** (Google AI)
