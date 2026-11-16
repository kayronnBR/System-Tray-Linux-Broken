# Bandeira do sistema Linux quebrada (ciclo de vida do aplicativo entre desktops e gerador de dock)

Um utilitário cross-desktop para Linux que automatiza o ciclo de vida de atalhos de aplicativos e ícones de dock/painel. Ele foi projetado para aplicativos que não possuem integração de banda natural ou funcional, fixação persistente ou gerenciamento adequado do ciclo de vida (como clientes Electron, AppImages e aplicativos da web empregados como Nerimity, Discord ou Spotify).

Quando você inicia o aplicativo, o utilitário injeta dinamicamente um atalho no painel ou dock do seu ambiente de trabalho ativo. Assim que o processo de inscrição termina, o atalho é removido de forma limpa, mantendo seu espaço de trabalho organizado.

---

## Como função

Diferentes ambientes de desktop Linux lidam com dores, docks e inicializadores por meio de APIs e estruturas de configuração totalmente diferentes. Portanto, o projeto fornece versões de script dedicadas para cada ambiente para lidar com injecção, posição e limpeza nativamente:

1. **Plasma do KDE:** Interage com o motor Plasma QML e D-Bus (`qdbus6`) para injetar e posicionar widgets de ícones do papel em relação à Bandeja do Sistema.
2. **GNOME Shell / XFCE / Outros DEs:** Interage com as respectivas configurações de dor ou esquemas de extensão.
3. **Invólucro transparente:** Gera um local `.área de trabalho` embrulhar em `~/.local/compartilhar/aplicativos/` apontando para um script de monitor em segundo plano (`-lançador.sh`) que rastreia o PID do aplicativo.

---

## Ambientes e backends suportados

* **Plasma KDE (5 e 6):** Totalmente suportado (`bandeira do sistema quebrada-kde.sh`).
* **GNOME Shell / XFCE / Outros DEs:** Se o seu ambiente de trabalho não está listado, **provavelmente está em desenvolvimento ou ainda não tem suporte.** Sinta-se à vontade para abrir uma edição ou contribuir!

---

## Pré-requisitos

* **Meio Ambiente:** Linux com ambiente de trabalho / gerador de janelas suportadas.
* **Ferramentas:** `batedor`, `pgrep` (`procps-ng`), `utilitários de arquivo de desktop` (`atualizar-banco-de-dados-da-desktop`) e ferramentas específicas do ambiente (por exemplo, `qdbus6` para o KDE).

---

## Instalação e uso

1. **Baixa o `.sh` versão do roteiro correspondente ao seu ambiente de trabalho.**
2. **Terminal Abra seu.**
3. **Arraste e solte o baixado `.sh` arquive diretamente na janela do terminal e impressão `Entrar`.**
4. Siga como instruções interativas no seu terminal para inserir o nome do aplicativo, o caminho do executável e a posição preferida.
5. Tudo pronto! Inicie seu aplicativo normalmente sem menu do sistema. O ícone aparecerá durante a execução e desaparecerá automaticamente ao sair.

---

## Estrutura de arquivo gerada

* `~/.local/bin/<app>-launcher.sh` — O script wrapper em segundo plano que manipula o ciclo de vida do tempo de execução, o monitoramento de processos (PID) e a inserção/remoção dinâmica de widgets/ícones.
* `~/.local/compartilhar/aplicativos/<aplicativo>.desktop` — O aplicativo de roteamento de entrada de desktop local atualizado é iniciado por meio do seu gerador de ciclo de vida personalizado.

---

## Créditos

* **Concepção, arquitetura, testes e visão multi-DE:** Kayronn monteiro
* **Desenvolvimento de código, mapeamento de mecanismo D-Bus/QML e lógica entre desktops:** **Gêmeos** (Google IA)
