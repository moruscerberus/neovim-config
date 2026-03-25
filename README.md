# Neovim Config for Rust and Python development

## Requirements
Rust and NodeJS

## Dependencies 
rustup component add rust-analyzer
npm install -g pyright


# Keybindings

## Editing

| Key | Action |
|-----|--------|
| Alt + ↑ | Move line up |
| Alt + ↓ | Move line down |
| Alt + K | Cut line |
| Alt + L | Select current line |
| Alt + Z | Undo |
| Alt + Y | Redo |

## Commenting

| Key | Action |
|-----|--------|
| Alt + . | Toggle comment |
| Alt + . (selection) | Toggle comments on selected lines |
| Alt + . (insert) | Comment without leaving insert |

## Selection (VSCode style)

| Key | Action |
|-----|--------|
| Shift + ↑ | Select up |
| Shift + ↓ | Select down |
| Shift + ← | Select left |
| Shift + → | Select right |

## Indentation

| Key | Action |
|-----|--------|
| Tab | Indent right |
| Shift + Tab | Indent left |
| Tab (selection) | Indent selection |
| Shift + Tab (selection) | Unindent selection |

## Scrolling

| Key | Action |
|-----|--------|
| Page Up | Scroll up |
| Page Down | Scroll down |
| Page Up (insert) | Scroll up |
| Page Down (insert) | Scroll down |

## LSP

| Key | Action |
|-----|--------|
| K | Hover documentation |
| gd | Go to definition |
| gD | Go to declaration |
| gi | Go to implementation |
| gr | References |
| [d | Previous diagnostic |
| ]d | Next diagnostic |
| leader + rn | Rename symbol |
| leader + ca | Code action |

## Autocomplete

| Key | Action |
|-----|--------|
| Ctrl + Space | Trigger completion |
| Ctrl + n | Next suggestion |
| Ctrl + p | Previous suggestion |
| Enter | Confirm selection |
