#!/bin/bash

echo "==========================================================="
echo "  System Tray Linux Broken (KDE Plasma 6 Widget Manager)"
echo "==========================================================="
echo "Select language / Selecione o idioma:"
echo "  1) Português (BR)"
echo "  2) English"
read -p "Choice / Escolha [1 or 2]: " LANG_CHOICE

if [ "$LANG_CHOICE" = "2" ]; then
    MSG_APP="Enter the exact app name (e.g., nerimity, discord, spotify): "
    MSG_BIN="Enter the full path to the executable or AppImage: "
    MSG_POS_TITLE="Where should the icon appear relative to the System Tray?"
    MSG_POS_1="  1) To the LEFT of the System Tray"
    MSG_POS_2="  2) To the RIGHT of the System Tray (between tray and clock)"
    MSG_POS_CHOICE="Choose [1 or 2]: "
    MSG_FOUND="✔ Original desktop shortcut found: "
    MSG_DONE="🎉 ALL SET! Launch the app from your application menu to test it."
    SIDE_LEFT="left"
    SIDE_RIGHT="right"
else
    MSG_APP="Digite o nome exato do app (ex: nerimity, discord, spotify): "
    MSG_BIN="Digite o caminho completo do executável ou AppImage: "
    MSG_POS_TITLE="Onde você quer que o ícone apareça em relação à Bandeja do Sistema (System Tray)?"
    MSG_POS_1="  1) À ESQUERDA do System Tray"
    MSG_POS_2="  2) À DIREITA do System Tray (entre a bandeja e o relógio)"
    MSG_POS_CHOICE="Escolha [1 ou 2]: "
    MSG_FOUND="✔ Atalho original encontrado: "
    MSG_DONE="🎉 PRONTO! Abra o aplicativo pelo menu iniciar para testar."
    SIDE_LEFT="esquerda"
    SIDE_RIGHT="direita"
fi

echo ""
read -p "$MSG_APP" APP_NAME
APP_LOWER=$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')
read -p "$MSG_BIN" APP_BIN

echo ""
echo "$MSG_POS_TITLE"
echo "$MSG_POS_1"
echo "$MSG_POS_2"
read -p "$MSG_POS_CHOICE" POS_CHOICE

if [ "$POS_CHOICE" = "2" ]; then
    SIDE="direita"
else
    SIDE="esquerda"
fi

DESKTOP_ORIGINAL=$(find /usr/share/applications ~/.local/share/applications -name "*${APP_LOWER}*.desktop" 2>/dev/null | head -n 1)
if [ -z "$DESKTOP_ORIGINAL" ]; then
    DESKTOP_FILE_NAME="${APP_LOWER}.desktop"
    DESKTOP_PATH_FULL="$HOME/.local/share/applications/$DESKTOP_FILE_NAME"
else
    DESKTOP_FILE_NAME=$(basename "$DESKTOP_ORIGINAL")
    DESKTOP_PATH_FULL="$HOME/.local/share/applications/$DESKTOP_FILE_NAME"
    echo "${MSG_FOUND}${DESKTOP_ORIGINAL}"
fi

# Limpa qualquer ícone residual do app no Painel 0
qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
    var p = panels()[0];
    var widgets = p.widgets();
    for (var j = 0; j < widgets.length; j++) {
        if (widgets[j].type == 'org.kde.plasma.icon') {
            widgets[j].currentConfigGroup = [];
            var u = String(widgets[j].readConfig('url')).toLowerCase();
            var lp = String(widgets[j].readConfig('localPath')).toLowerCase();
            if (u.indexOf('${APP_LOWER}') !== -1 || lp.indexOf('${APP_LOWER}') !== -1) {
                widgets[j].remove();
            }
        }
    }
"
rm -f "$HOME/.local/share/plasma_icons/"*"${APP_LOWER}"* 2>/dev/null

mkdir -p ~/.local/bin
LAUNCHER_PATH="$HOME/.local/bin/${APP_LOWER}-launcher.sh"

cat << EOF > "$LAUNCHER_PATH"
#!/bin/bash
APP_BIN="$APP_BIN"
APP_LOWER="$APP_LOWER"
DESKTOP_FILE_NAME="$DESKTOP_FILE_NAME"
SIDE="$SIDE"
DESKTOP_PATH="$DESKTOP_PATH_FULL"

gerenciar_widget() {
    local acao=\$1
    if [ "\$acao" = "criar" ]; then
        qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
            var p = panels()[0];
            var widgets = p.widgets();
            var jaExiste = false;

            for (var j = 0; j < widgets.length; j++) {
                if (widgets[j].type == 'org.kde.plasma.icon') {
                    widgets[j].currentConfigGroup = [];
                    var u = String(widgets[j].readConfig('url')).toLowerCase();
                    var lp = String(widgets[j].readConfig('localPath')).toLowerCase();
                    if (u.indexOf('\$APP_LOWER') !== -1 || lp.indexOf('\$APP_LOWER') !== -1) {
                        jaExiste = true;
                        break;
                    }
                }
            }

            if (!jaExiste) {
                var clockW = null;
                var trayW = null;
                var trayExtra = '';
                var trayKnown = '';

                for (var j = 0; j < widgets.length; j++) {
                    if (widgets[j].type == 'org.kde.plasma.digitalclock') {
                        clockW = widgets[j];
                    } else if (widgets[j].type == 'org.kde.plasma.systemtray') {
                        trayW = widgets[j];
                        trayW.currentConfigGroup = ['General'];
                        trayExtra = String(trayW.readConfig('extraItems'));
                        trayKnown = String(trayW.readConfig('knownItems'));
                    }
                }

                if ('\$SIDE' === 'esquerda') {
                    if (trayW) trayW.remove();
                    if (clockW) clockW.remove();

                    var w = p.addWidget('org.kde.plasma.icon');
                    w.currentConfigGroup = [];
                    w.writeConfig('url', 'file://\$DESKTOP_PATH');

                    var newTray = p.addWidget('org.kde.plasma.systemtray');
                    newTray.currentConfigGroup = ['General'];
                    if (trayExtra) newTray.writeConfig('extraItems', trayExtra);
                    if (trayKnown) newTray.writeConfig('knownItems', trayKnown);

                    p.addWidget('org.kde.plasma.digitalclock');
                } else {
                    if (clockW) clockW.remove();

                    var w = p.addWidget('org.kde.plasma.icon');
                    w.currentConfigGroup = [];
                    w.writeConfig('url', 'file://\$DESKTOP_PATH');

                    p.addWidget('org.kde.plasma.digitalclock');
                }
            }
        "
    elif [ "\$acao" = "remover" ]; then
        qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
            var p = panels()[0];
            var widgets = p.widgets();
            for (var j = 0; j < widgets.length; j++) {
                if (widgets[j].type == 'org.kde.plasma.icon') {
                    widgets[j].currentConfigGroup = [];
                    var u = String(widgets[j].readConfig('url')).toLowerCase();
                    var lp = String(widgets[j].readConfig('localPath')).toLowerCase();
                    if (u.indexOf('\$APP_LOWER') !== -1 || lp.indexOf('\$APP_LOWER') !== -1 || u.indexOf('\$DESKTOP_FILE_NAME'.toLowerCase()) !== -1) {
                        widgets[j].remove();
                    }
                }
            }
        "
        rm -f "\$HOME/.local/share/plasma_icons/"*"\${APP_LOWER}"* 2>/dev/null
    fi
}

if pgrep -f "^\$APP_BIN" > /dev/null; then
    "\$APP_BIN" &
    exit 0
fi

gerenciar_widget "criar"
"\$APP_BIN" &
APP_PID=\$!

sleep 2
while kill -0 \$APP_PID 2>/dev/null || pgrep -f "^\$APP_BIN" > /dev/null; do
    sleep 2
done

gerenciar_widget "remover"
EOF

chmod +x "$LAUNCHER_PATH"

if [ -n "$DESKTOP_ORIGINAL" ] && [ -f "$DESKTOP_ORIGINAL" ]; then
    cp "$DESKTOP_ORIGINAL" "$DESKTOP_PATH_FULL"
    sed -i "s|^Exec=.*|Exec=$LAUNCHER_PATH|g" "$DESKTOP_PATH_FULL"
else
    cat << EOF > "$DESKTOP_PATH_FULL"
[Desktop Entry]
Type=Application
Name=$APP_NAME
Exec=$LAUNCHER_PATH
Icon=$APP_LOWER
Terminal=false
Categories=Utility;
EOF
fi

update-desktop-database ~/.local/share/applications/
echo ""
echo "$MSG_DONE"
