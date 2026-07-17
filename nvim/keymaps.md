# 🎯 Neovim Workflow Cheatsheet

## 1. Terminal (ToggleTerm)
Dein intelligenter Runner und Server, der merkt, ob du in einem Angular- oder Node-Projekt bist.

* `<leader>tt` oder `<leader>t1` -> Öffnet/Schließt das standardmäßige schwebende (Floating) Terminal.
* `<leader>t2` / `<leader>t3` -> Schaltet weitere separate schwebende Terminals um.
* `<leader>tr` -> **Smart Runner:** Startet oder wiederholt deinen Test/Build-Befehl (z. B. `ng test` oder `npm start`).
* `<leader>ts` -> **Smart Server:** Startet oder toggelt deinen Dev-Server (z. B. `ng serve` oder `npm run dev`) im horizontalen Split.
* `<leader>tR` / `<leader>tS` -> Konfiguration erzwingen (frägt dich nach einem neuen Befehl für Runner/Server).
* `<leader>to` -> Zeigt dir das Output-Fenster deines letzten Runners an, ohne ihn neu zu starten.

**Im aktiven Terminal-Fenster:**
* `<esc>` -> Wechselt in den Normal-Mode des Terminals (um Text zu kopieren oder zu scrollen).
* `q` -> Schließt das Terminal-Fenster blitzschnell (im Normal-Mode).
* `Strg + h/j/k/l` -> Direktes Springen aus dem Terminal in andere Neovim-Fenster.

---

## 2. Autocompletion (Blink.cmp)
Dein rahmenloses, kompaktes und unvorstellbar schnelles Completion-Menü.

* `Strg + j` -> Navigiert zum **nächsten** Vorschlag in der Liste.
* `Strg + k` -> Navigiert zum **vorherigen** Vorschlag in der Liste.
* `<CR>` (Enter) -> Akzeptiert den ausgewählten Vorschlag und fügt ihn ein.
* `Strg + Leerzeichen` -> Öffnet das Vorschlags-Menü manuell oder toggelt die Dokumentation dazu.
* `Strg + f` / `Strg + b` -> Scrollt die geöffnete Dokumentation nach unten oder oben.

---

## 3. Navigation & Projekt-Fokus (Harpoon 2)
Vergiss Tab-Leisten – springe direkt zwischen deinen 3–4 wichtigsten Projektdateien hin und her.

* `<leader>ha` -> Heftet die aktuelle Datei an deine Harpoon-Liste an (erstellt einen Slot).
* `<leader>he` -> Öffnet das rahmenlose Harpoon-Menü (kann wie ein Textpuffer mit `dd` bearbeitet werden).
* `<leader>h1` -> Direktsprung zu **Slot 1** (z. B. deine `.ts`-Komponente).
* `<leader>h2` -> Direktsprung zu **Slot 2** (z. B. dein `.html`-Template).
* `<leader>h3` -> Direktsprung zu **Slot 3** (z. B. deine `.css`-Styles).
* `<leader>h4` -> Direktsprung zu **Slot 4** (z. B. dein Service oder die API).
* `<leader>hn` / `<leader>hp` -> Zyklisch zur nächsten oder vorherigen Datei der Liste blättern.

---

## 4. Code-Intelligenz (LSP)
Deine IDE-Features, die nur dann aktiv sind, wenn ein Language Server (wie `vtsls` oder `angularls`) läuft.

* `gd` -> **Go to Definition:** Springt direkt zur Quelle der Variable, Methode oder Klasse.
* `gr` -> **Find References:** Zeigt dir im Quickfix-Fenster überall an, wo das Element im Projekt genutzt wird.
* `K`  -> **Hover:** Zeigt dir Typdefinitionen und Dokumentationen direkt am Cursor an.
* `<leader>rn` -> **Rename:** Benennt die Variable oder Methode projektweit und sicher um.
* `<leader>ca` -> **Code Action:** Öffnet automatische Quick-Fixes oder Imports (sehr mächtig bei TypeScript!).
* `]d` / `[d` -> Springt zum nächsten oder vorherigen LSP-Fehler / der nächsten Warnung in der Datei.

---

## 5. Git-Integration (Fugitive & Gitsigns)
* `<leader>gs` -> Öffnet das interaktive **Fugitive-Git-Status**-Fenster.
  * *Tipp im Fenster:* Fahre auf eine Datei und drücke `s` zum Stagen, `u` zum Unstagen, `cc` zum Committen.
* `]c` / `[c` -> Springt direkt zur nächsten oder vorherigen Änderung (Hunk) in deiner Datei.
* `<leader>hp` -> **Hunk Preview:** Zeigt ein rahmenloses Popup mit der exakten Zeilen-Diff an.
* `<leader>hs` / `<leader>hr` -> Stagt (`s`) oder verwirft (`r`) die Git-Änderung des aktuellen Blocks direkt im Code.

---

## 6. Code-Formatierung (Conform)
* `:w` (Speichern) -> Formatiert deine Datei vollautomatisch, synchron und blitzschnell im Hintergrund via `prettierd` (Web) oder `stylua` (Neovim-Config).
* `<leader>mp` -> Formatiert die aktuelle Datei (oder im Visual-Mode den markierten Bereich) sofort manuell.
