## Workflow

- Read the spec and implement only the step I name. Add nothing beyond it.
- Check your work lightly:
  - Neovim starts without errors: `nvim --headless +qa`
  - New keymaps exist: `verbose map <key>`
- Don't build test projects or drive the UI. I check the behavior myself after `ZR`.

## 0. Prerequisites

### 0.1 Neovim

- Neovim 0.12 or newer
  - The config relies on built-ins that landed in 0.12:
    - `vim.pack`, `vim.lsp.enable` and the ui2 message UI.

### 0.2 CLI tools

- `git`: `vim.pack` clones plugins with it.
- `tree-sitter`: CLI and a Ccompiler: `nvim-treesitter`'s main branch builds parsers locally
- `curl` and `tar`: parser and blink.cmp binary downloads
- Node.js + npm: `Mason` installs most language servers through npm.
- `ripgrep` and `fd`: back the text search and the file finder.
- `lazygit` and `git-delta`: the git UI and tis diff renderer

### 0.3 Font

- A Nerd Font, PlemolJP Console NF.
  - Icons appear in the tabline, statusline, completion menu and file explorer so a plain font shows boxes

### 0.4 Git

- The config folder is a git repository
- `.gitignore` lists `nvim-pack-lock.json`

## 1. Foundation

### 1.1 Layout

- `~/.config/nvim`: the config root folder
  - `init.lua`: enables `vim.loader` for faster startup, then requires these files directly, in order:
  - `dleiadev.utils`, assigned to global `DleiaDev`
  - `dleiadev.config.options`, `.keymaps`, `.autocmds`, `.commands`, `.workarounds`
  - `dleiadev.plugins`
- `lua/dleiadev`: my config lives here
  - `utils`: shared helpers
    - `init.lua`: returns a table or helper modules, empty for now. Later steps add modules like `utils/editor.lua`, exposed as `editor`
  - `config/`: plain Neovim settings, one file per name above
  - `plugins/`
    - `init.lua`: will install every plugin in one `vim.pack.add` call, then require each group file
    - Each plugin group gets its own file next to it later (e.g. `ui.lua`), which configures its plugins with `require("<plugin>").setup({})`
  - `keymaps.lua`: every keymap that uses a plugin, required last so all plugins are setup first. Group files hold no keymaps.
- Lua files are indented with tabs, formatted with stylua with its defaults

### 1.2 Leader and basics

- Leader and local leader are **Space**.
- Mouse is **off**. Keyboard-only.
- Clipboard is `unnamedplus` so yank and paste go through the system clipboard.
- Indent is **2 spaces**: `tabstop`, `shiftwidth`, and `softtabstop` are all **2**, with `expandtab` and `smartindent` **on**.
  - `-` counts as part of a word, so `foo-bar` is one word.
    - Fits CSS classes and kebab-case names.

### 1.3 Look of the buffer

- **Hybrid** line numbers: `number` + `relativenumber` **on**, so the cursor line shows its real number.
- `cursorline` **on**. No wrap, `scrolloff` **10**, `sidescrolloff` **8**.
- `signcolumn` **always on**.
  - Text doesn't jump when git or diagnostic marks appear.
  - `cmdheight` **0** and one global statusline (`laststatus` **3**).
  - Maximizes vertical space.
  - **Rounded** borders on every float (`winborder`).
  - Popup menu: at most **10** rows, slightly see-through (`pumheight` **10**, `pumblend` **10**).
  - Matching brackets flash briefly (`showmatch` **on**, `matchtime` **2**).
  - `title` **on**, so the terminal tab shows the file name.
  - Diagonal `/` fill in empty diff areas.

### 1.4 Search, files, undo

- `ignorecase` + `smartcase` **on**: case-insensitive until a capital letter is typed.
- `path` adds `**` , so `:find` searches subfolders.
- `:` completion: `wildmode` is `ongest:full`, `full`. `wildignore` skips `*/node_modules/**`, `*.o`, `*.obj`, `*.pyc`, `*.class`, `*.jar`.
- `swapfile` and `writebackup` **off**. Persistent undo (`undofile` **on**) lives in `*~/.cache/nvim/undodir`
  - Undo survives closing the file. Swap files only get in the way.
- Snappier timing: `updatetime` **300**, `timeoutlen` **500**, `ttimeoutlen` **0**.
  - Faster CursorHold events, and key sequences resolve without lag.

### 1.5 Splits and folds

- New splits open **below** and to the **right**.
- Folds come from **Treesitter**, with `foldlevel` **99**.
  - Everything starts unfolded, and folds can still be closed by syntax.

### 1.6 Messages

- Neovim 0.12's experimental ui2 handles messages. Turn it on at the end of `config/options.lua`
- Short messages: corner popup up to **30%** of the screen tall, gone after **5 seconds**.
- Long output (errors, listings like `:ls`, `:verbose`, shell commands and their output, progress): a scrollable pager up to **half** the screen.
- Search count, search pattern, completion, `:` completion list, and confirm prompts stay in the command line.
- Output of a command I type goes to the command line too, whatever its kind. It expands over the bottom of the screen until the next key, and `Enter` moves it into the pager.
- tiny-cmdline.nvim shows the `:` command line as a floating box centered left to right, **20%** from the top. It's set up in `plugins/ui.lua`
- With `cmdheight` O the command line needs somewhere to appear, and near the top is where the eyes already are.

### 1.7 Autocmds

- Yanked text flashes briefly
- Only the active window shows the cursorline

### 1.8 Core keymaps

| Keys                                | Action                                                                | Notes                                               |
| ----------------------------------- | --------------------------------------------------------------------- | --------------------------------------------------- |
| `x`                                 | Deletes without copying                                               |                                                     |
| `<leader>d` `<leader>c` `<leader>p` | Delete, change and paste without touching the yank register           | The yanked text stays safe while editing around it. |
| `dw`                                | Deletes the word backwards without copying                            |                                                     |
| `+` / `-`                           | Increment and decrement numbers                                       |                                                     |
| `<C-a>`                             | Selects all                                                           |                                                     |
| `te`                                | Opens a new tab                                                       |                                                     |
| `Tab` / `Shift-Tab`                 | Cycle tabs                                                            |                                                     |
| `ss` / `sv`                         | Split                                                                 | Short, home-row window control                      |
| `sh` `sj` `sk` `sl`                 | Move between windows                                                  | Short, home-row window control                      |
| `<C-m>`                             | Jumps forward in the jump list                                        |                                                     |
| `<leader>o` / `<leader>O`           | Open a line below or above without continuing a comment (`o<Esc>^Da`) |                                                     |

### 1.9 Close hidden buffers

- `<leader>bd` closes every hidden buffer, except unsaved ones.

## 2. Look and feel

### 2.1 Colorscheme

- folke/tokyonight.nvim: light/dark variant is set by the terminal (wezterm)
  - Neovim's background should be transaprent and blurred to match the transparency and blurness level of Wezterm:
    - config.window_background_opacity = 0.9
    - config.macos_window_background_blur = 20

### 2.2 Icons

- mini.icons, also mocking nvim-web-devicons
  - One icon source for every plugin

### 2.3 Tabline

- Custom tabline in `utils/tabline.lua`, shown only when there are **2** or more tabs.
- Each tab shows the active window's file name with its icon, padded with **3** spaces:
  - Active and inactive tab with colors from the colorscheme palette The icon takes the tab's text color.
  - Tabs sit directly next to each other, with no separators or gaps between them. The empty area after the last tab is transparent.
- Names longer than **20** characters are cut to **17** oplus `...` Unsaved tabs show `[+]` before the icon.
- Terminal show `[Terminal]` and empty buffers `[No Name]`, with no icon.

### 2.4 Statusline

- lualine, one global bar, theme `auto`.
  - a: mode
  - b: git branch
  - c: project root name (only when it differs from cwd), filetype icon, pretty file path
  - x: macro recording register, diagnostics, git diff counts
  - y: progress
  - z: line:column
- The project root is found by searching upward for `.git`,`lua`, `package.json`, `Makefile`, `Cargo.toml`,`go.mod`, or `pyproject.tom1`.
- Refreshes on cursor move and macro start/stop.
  - The recording indicator replaces the hidden command line.

### 2.5 Window labels

- incline.nvim shows a filename tag with an icon in the top-right corner of each window, plus `[+]` when unsaved.
  - With a single global statusline, each split still needs to say which file it holds.
- An unnamed buffer shows `[No Name]`.
- The focused window's tag uses the active tab colors from the tabline (2.3), the others the inactive ones. The icon takes the tag's text color.
  - Shows at a glance which window I'm working in.
- The focused window's tag hides when the cursor reaches its line. Tags of other windows always show.

### 2.6 Snacks

- snacks.nvim provides notifier, indent guides, statuscolumn, and word highlighting.
  - I'll turn on more of it in later steps, like the picker and the lazygit integration.
- Words: the word under the cursor is highlighted everywhere. `]]` / `[[` jump between occurrences.
- Smooth scroll is **off**.
  - Scrolling should feel instant

## 3. Navigation

### 3.1 Picker

- snacks.nvim picker

| Keys | Action                             | Notes                                                                 |
| ---- | ---------------------------------- | --------------------------------------------------------------------- |
| `;f` | Finds file, including hidden ones  | Dotfiles like `.github` and `.env.example` are part of real projects. |
| `;r` | Live-greps, including hidden files |                                                                       |
| `;;` | Reopens the last picker            |                                                                       |
| `\\` | Lists open buffers                 | Jumps to a window that already shows the buffer.                      |
| `;e` | Lists diagnostiscs                 |                                                                       |
| `;n` | Shows notifications history        |                                                                       |
| `;h` | Lists git hunks                    |                                                                       |

### 3.2 File explorer

- oil.nvim replaces netrw and shows hidden files.
  - The directory is a buffer, so renaming, moving, and deleting files is plain text editing followed by `:w`
- Columns: icon, permissins, size, modified time.
- Renaming a file asks the LSP to update imports and saves those edits automatically.
- In the tabline (2.3), an oil tab shows its directory (`~/foo`) with no icon. Paths longer than **20** characters are cut from the left to ... plus the last **17**.

| Keys | Action                                          | Notes                                             |
| ---- | ----------------------------------------------- | ------------------------------------------------- |
| `sf` | Opens oil as centered float with a live preview | At most **200** colmns wide, with rounded corners |
| `h`  | Goes to the parent directory                    |                                                   |
| `q`  | Closes oil                                      |                                                   |

## 4. Syntax

### 4.1 Treesitter

- nvim-treesitter, main branch.
- Ensures 38 parsers: astro, bash, c, cmake, cpp, css, diff, fish, gitignore, go, grephql, html, http, java, javascript, jsdoc, json, lua, Luadoc, luap, markdown, markdown_inline, php, printf, python, query, regex, rust, scss, sql, svelte, toml, tsx, typescript, vim, vimdoc, xml, yaml, terraform.
- A FileType autocmd starts highlighting and Treesitter indent whenever a parser exists.
- `:TSUpdate` runs on the `PackChanged` event.
  - Parsers stay in sync with the plugin version.

### 4.2

### 4.3 Small highlights

- todo-comments.nvim highlights `TODO`, `FIXME`, and the like, with defaults.
- nvim-highlight-colors paints hex, rgb, hsl, ANSI, and CSS variable colors as backgrounds. Tailwind is off.
  - Neovim's LSP document colors are turned off, so colors aren't painted twice.

## 5. Code smarts

### 5.1 Language servers

- Mason + mason-tool-installer install on start, never auto-update:
  - Servers: Lua-Language-server, vtsls, eslint-Isp, oxlint, tailwindess-Language-server, css-1sp, rust-analyzer, copilot-language-server
  - Formatters: prettier, prettierd, oximt, stylua, shfmt
- nvim-lspconfig supplies defaults. Servers are turned on with `vim.lsp. enable`: eslint, oxlint, lua_ls, cssls, vtsis, tailwindess, rust_analyzer.
- Every server gets file-rename support (`didRename` / `willRename`)

### 5.2 Diagnostics look

- Underlined, not updated while typing, sorted by severity.
- Inline text: `<icon> message`, with the source only when there are several.
- Gutter icons, inline text and the diagnostic float all use the severity icons from the shared icon set (`utils/icons.lua`).

### 5.3 Per-server settings

- Per-server settings live in `after/lsp/<name>.lua`
  - Neovim 0.12 merges these automatically, so there's no setup boilerplate.
- vtsls:
  - Uses the workspace TypeScript and updates imports on file move.
  - Server-side fuzzy matching and function-call completion.
  - Inlay hints are short: no variable types, **30** characters max.
- lua_l: knows the Neovim runtime, shows param-type hints, silences a few noisy checks.
- cssls: ignores empty rules.
- oxlint: starts with `oxlint --lsp`.

### 5.4 Completion

- blink.cmp, version `^1`, `enter` preset: Enter accepts.
- Every language server from 5.1 also gets blink.cmp's completion capabilities.
- Auto-brackets after functions. Docs pop up after **200ms**.
- Menu items are colorized by Treesitter, with kind icons from the shared icon set.
- Ghost text is **off**.
  - Copilot already shows inline suggestions, and two ghost texts would clash.
- In the command line, the menu opens by itself for `:` commands only, with nothing preselected.

### 5.5 Pairs

- mini.pairs with defaults, in insert and command mode

### 5.6 Formatting

- conform nvim formats on save with a **1000ms** timeout, falling back to the LSP.
- Web files (js, ts, jsx, tsx, ison, css, scss, less, html, markdown, mdx, yam1): oxfmt, then prettierd, then prettier, using the first available.
  - oxfmt runs only when the project has an oxfmt config, like ' oxfmtrc. json' or a Vitet 'vite config.ts', so projects using prettier keep their own formatter.
- lua: stylua. sh: shfmt. fish: fish_indent.
- `:ToggleFormatter` turns format-on-save off or back on for the current buffer, with a notification. The command lives in `config/commands.lua`

### 5.7 LSP keymaps

| Keys                    | Action                                                                            | Notes                                        |
| ----------------------- | --------------------------------------------------------------------------------- | -------------------------------------------- |
| `gd`                    | Goes to definition                                                                | Through the picker, like `gD`, `gy` and `gr` |
| `gD`                    | Goes to declaration                                                               |                                              |
| `gY`                    | Goes to the type definition                                                       |                                              |
| `gr`                    | Lists references                                                                  |                                              |
| `gI`                    | Goes to the source definition in TypeScript, the implemntation in other languages | Skips `.d.ts` to reach the real code         |
| `;c`                    | Lists incoming calls                                                              |                                              |
| `K`                     | Shows hover docs                                                                  |                                              |
| `gK` / `<C-k>` (insert) | Show signature help                                                               |                                              |
| `<C-j>`                 | Jumps to the next diagnostic in a float                                           |                                              |
| `<leader>ca`            | Shows code actions                                                                |                                              |
| `<leader>cr`            | Renames the symbol                                                                |                                              |
| `<leader>cR`            | Renames the file with import updates                                              |                                              |
| `<leader>f`             | Formats now                                                                       |                                              |
| `<leader>cl`            | Shows LSP info                                                                    |                                              |

## 6. Git

### 6.1 Signs and blame

- gitsigns.nvim with defaults

| Keys         | Action                                                                   | Notes                                                         |
| ------------ | ------------------------------------------------------------------------ | ------------------------------------------------------------- |
| `<leader>gb` | Blames the line                                                          |                                                               |
| `<leader>gB` | Blames the buffer                                                        |                                                               |
| `<leader>go` | Opens the file as of the commit that last touched the line, in a new tab | Shows the context of an old change without leaving the editor |
| `<leader>gs` | Stages the buffer or unstages it if nothing is left to stage             |                                                               |
| `<leader>gh` | Stages or unstages the hunk                                              |                                                               |

### 6.2 Diff

- mini.diff (craftzdog fork: `craftzdog/mini.diff`) with defaults

| Keys         | Action              | Notes |
| ------------ | ------------------- | ----- |
| `<leader>gd` | Toggles the overlay |       |
| `]c` / `[c`  | Jump between hunks  |       |

### 6.3 Diff view

- codediff.nvim for side-by-side diffs and history
  - I use codediff when my agent makes a lot of changes in the codebase
- Explorer: **tree** view, **50** columns wide, opens files as the cursor moves, shows +/- line stats.
- Compact mode: only changes plus **8** context lines, with folds synced across panes.

| Keys         | Action                           |
| ------------ | -------------------------------- |
| `<leader>dv` | Toggles the diff view            |
| `<leader>dh` | Shows the current file's history |
| `<leader>dH` | Shows the repo history           |

### 6.4 Lazygit

- `;g` opens lazygit in a float through snacks.nvim, with the theme synced and the active border in the WarningMsg color.
- Pressing `e` on a file closes lazygit and opens the file in the window It was launched from, through `$NVIM` and `nvim --server --remote`
  - `;g` remembers the current window. `e` quits lazygit, focuses that window with `--remote-send`, then opens the file, so the cursor ends up in the file.
  - Not a new tab and not a nested Neovim. Outside Neovim it just runs `nvim <file>`
  - The edit command is written in oh my zsh syntax.
- Lazygit's own condif lives in `~/.config/lazgit/config.yml`, outside the Neovim config. snacks.nvim loads it together with the synced theme. It holds:

## Agentic coding

### 7.1 Copy paths for agents

| Keys         | Action                                                         | Notes                                       |
| ------------ | -------------------------------------------------------------- | ------------------------------------------- |
| `<leader>yf` | Copies the current file's path relative to cwd with `#L<line>` | e.g. `lua/craftzdog/config/options.lua#L12` |
| `<leader>yp` | Copies the absolute path in the same way                       |                                             |

- Both show copied text in a notification
  - Pasting the path into an agen't prompt points it at the exact line

  ## 8.2 Helper keymaps

  | Keys                  | Action                                                                               |
  | --------------------- | ------------------------------------------------------------------------------------ |
  | `<leader>cc` (visual) | Copies the selection as Markdown code block                                          |     |
  | `<leader>j`           | Opens a project's `package.json` in a centered **80%** float. `q` or `Esc` closes it |     |
