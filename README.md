<div align = "center">

<h1><a href="https://github.com/2kabhishek/exercism.nvim">exercism.nvim</a></h1>

<a href="https://github.com/2KAbhishek/exercism.nvim/blob/main/LICENSE">
<img alt="License" src="https://img.shields.io/github/license/2kabhishek/exercism.nvim?style=flat&color=eee&label="> </a>

<a href="https://github.com/2KAbhishek/exercism.nvim/graphs/contributors">
<img alt="People" src="https://img.shields.io/github/contributors/2kabhishek/exercism.nvim?style=flat&color=ffaaf2&label=People"> </a>

<a href="https://github.com/2KAbhishek/exercism.nvim/stargazers">
<img alt="Stars" src="https://img.shields.io/github/stars/2kabhishek/exercism.nvim?style=flat&color=98c379&label=Stars"></a>

<a href="https://github.com/2KAbhishek/exercism.nvim/network/members">
<img alt="Forks" src="https://img.shields.io/github/forks/2kabhishek/exercism.nvim?style=flat&color=66a8e0&label=Forks"> </a>

<a href="https://github.com/2KAbhishek/exercism.nvim/watchers">
<img alt="Watches" src="https://img.shields.io/github/watchers/2kabhishek/exercism.nvim?style=flat&color=f5d08b&label=Watches"> </a>

<a href="https://github.com/2KAbhishek/exercism.nvim/pulse">
<img alt="Last Updated" src="https://img.shields.io/github/last-commit/2kabhishek/exercism.nvim?style=flat&color=e06c75&label="> </a>

<h3>Exercism Meets Neovim 💪🧠</h3>

<figure>
  <img src="doc/images/screenshot.png" alt="exercism.nvim in action">
  <br/>
  <figcaption>exercism.nvim in action</figcaption>
</figure>

</div>

exercism.nvim integrates exercism into Neovim by providing a set of commands and keybindngs to help you solve exercises faster.

## ✨ Features

- Browse and choose exercises from the entire exercism library from within Neovim
- Quickly test and submit your solutions
- Review your existing solution for an exercise
- Track and revisit recently opened exercises
- Simple keybindings and commands to make your workflow faster

## ⚡ Setup

### ⚙️ Requirements

- [utils.nvim](https://github.com/2kabhishek/utils.nvim) for utility functions
- [termin.nvim](https://github.com/2kabhishek/terminal.nvim) for terminal support

- [exercism-cli](https://exercism.io/cli) installed and configured
  - Make sure to login with `exercism configure`
- [tmux-tea](https://github.com/2kabhishek/tmux-tea) (optional, recommended) for separate tmux sessions for each exercise
  - Use `set -g @tea-default-command 'nvim'` for a better experience

### 💻 Installation

```lua
-- Lazy
{
    '2kabhishek/exercism.nvim',
    cmd = { 'Exercism' },
    keys = { '<leader>exa', '<leader>exl', '<leader>exr' }, -- add your preferred keybindings
    dependencies = {
        '2kabhishek/utils.nvim', -- required, for utility functions
        '2kabhishek/termim.nvim', -- optional, better UX for running tests
    },
    -- Add your custom configs here, keep it blank for default configs (required)
    opts = {},
},
```

## 🚀 Usage

### Configuration

```lua
exercism.setup({
    exercism_workspace = '~/exercism', -- Default workspace for exercism exercises
    default_language = 'ruby', -- Default language for exercise list
    add_default_keybindings = true, -- Whether to add default keybindings
    use_new_command = false, -- Use new Exercism command
    max_recents = 30, -- Maximum number of recent exercises to keep
    icons = {
        concept = '', -- Icon for concept exercises
        practice = '', -- Icon for practice exercises
    },
})
```

### Commands

`exercism.nvim` provides a unified command interface with tab completion:

- `Exercism languages` - Lists all available languages, select one to list exercises
- `Exercism list [language]` - Lists exercises for the specified language, show exercises for default language if not specified
- `Exercism test` - Runs tests for the current exercise
- `Exercism submit` - Submits the current exercise
- `Exercism open <language> <exercise>` - Opens a specific exercise directly in the specified language
- `Exercism exercise <exercise>` - Opens a specific exercise directly using the default language
- `Exercism recents` - Shows recently opened exercises in a fuzzy searchable list

#### Deprecated Commands

> **⚠️ DEPRECATION NOTICE**: The following commands are deprecated and will be removed in a future version. Please migrate to the new `Exercism` commands above.
> More information: https://github.com/2kabhishek/exercism.nvim/issues/4

- `ExercismLanguages` → `Exercism languages`
- `ExercismList [language]` → `Exercism list [language]`
- `ExercismTest` → `Exercism test`
- `ExercismSubmit` → `Exercism submit`

### Keybindings

Here are the default keybindings:

| Keybinding    | Command                    | Description                               |
| ------------- | -------------------------- | ----------------------------------------- |
| `<leader>exa` | `Exercism languages`       | List all available languages              |
| `<leader>exl` | `Exercism list [language]` | List exercises for the specified language |
| `<leader>ext` | `Exercism test`            | Run tests for the current exercise        |
| `<leader>exs` | `Exercism submit`          | Submit the current exercise               |

> You can change these by setting `add_default_keybindings` to `false` and adding your own keybindings.

### Help

Run `:help exercism.txt` for more details.

## 🏗️ What's Next

### ✅ To-Do

- [ ] Add tests

## ⛅ Behind The Code

### 🌈 Inspiration

I really like exercism but the back and forth between the browser and the terminal was a bit annoying. So I decided to integrate it with Neovim.

### 💡 Challenges/Learnings

- I build [exercism-fetcher](https://github.com/2kabhishek/exercism-fetcher) to fetch exercises from exercism's github repos.
- Reused knowledge from octohub.nvim, not too many challenges here.

### 🔍 More Info

- [octohub.nvim](https://github.com/2kabhishek/octohub.nvim) — GitHub Repos in Neovim
- [nerdy.nvim](https://github.com/2kabhishek/nerdy.nvim) — Find nerd glyphs easily
- [tdo.nvim](https://github.com/2KAbhishek/tdo.nvim) — Fast and simple notes in Neovim
- [termim.nvim](https://github.com/2kabhishek/termim.nvim) — Neovim terminal improved

<hr>

<div align="center">

<strong>⭐ hit the star button if you found this useful ⭐</strong><br>

<a href="https://github.com/2KAbhishek/exercism.nvim">Source</a>
| <a href="https://2kabhishek.github.io/blog" target="_blank">Blog </a>
| <a href="https://twitter.com/2kabhishek" target="_blank">Twitter </a>
| <a href="https://linkedin.com/in/2kabhishek" target="_blank">LinkedIn </a>
| <a href="https://2kabhishek.github.io/links" target="_blank">More Links </a>
| <a href="https://2kabhishek.github.io/projects" target="_blank">Other Projects </a>

</div>
