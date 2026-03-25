Neovim Config for Rust and Python development
=============================================

Requirements
------------

Rust and NodeJS

Dependencies
------------

rustup component add rust-analyzernpm install -g pyright

Keybindings
===========

Editing
-------

Alt + ↑ — Move line upAlt + ↓ — Move line downAlt + K — Cut lineAlt + L — Select current lineAlt + Z — UndoAlt + Y — Redo

Commenting
----------

Alt + . — Toggle commentAlt + . (selection) — Toggle comments on selected linesAlt + . (insert) — Comment without leaving insert

Selection (VSCode style)
------------------------

Shift + ↑ — Select upShift + ↓ — Select downShift + ← — Select leftShift + → — Select right

Indentation
-----------

Tab — Indent rightShift + Tab — Indent leftTab (selection) — Indent selectionShift + Tab (selection) — Unindent selection

Scrolling
---------

Page Up — Scroll upPage Down — Scroll downPage Up (insert) — Scroll upPage Down (insert) — Scroll down

LSP
---

K — Hover documentationgd — Go to definitiongD — Go to declarationgi — Go to implementationgr — References\[d — Previous diagnostic\]d — Next diagnosticleader + rn — Rename symbolleader + ca — Code action

Autocomplete
------------

Ctrl + Space — Trigger completionCtrl + n — Next suggestionCtrl + p — Previous suggestionEnter — Confirm selection
