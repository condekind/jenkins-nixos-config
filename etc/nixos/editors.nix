{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    tmux
  ];

  # Basic neovim configuration
  environment.etc."nvim/init.vim".text = ''
scriptencoding utf-8
set encoding=utf-8
" --------------------------------indentation-------------------------------- "

" Use the same value for these. If you want to break that, read :help tabstop
set tabstop=2       " num of spaces a tab accounts for
set softtabstop=2   " num of spaces a tab appears as
set shiftwidth=2    " num of spaces used by autoindent
set expandtab       " expand tab to spaces

set shiftround      " round indents to multiples of shiftwidth
set autoindent      " autoindents newlines
set smartindent     " matches closing characters to their pair's indentation
set copyindent      " copies indentation characters used in last line

let g:vim_indent_cont=8     " indent added for continuation lines in vimscript

set bs=indent,eol,start     " regular backspace behavior
syntax   on                 " syntax highlighting
filetype on                 " triggers autocommands for your file's type

" File reload on external commands and changing buffers
au FocusGained,BufEnter * :checktime

set undofile
set undolevels=65535

set foldmethod=marker

" ---------------------------------eye candy--------------------------------- "

" For Neovim 0.1.3 and 0.1.4 (https://github.com/neovim/neovim/pull/2198)
if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

hi MatchParen cterm=bold,italic ctermbg=none ctermfg=Yellow
set cc=80,110 " columns on which rulers are drawn
hi cc ctermbg=lightblue
set rnu       " show line numbers relative to the current one
set nu        " show absolute line number on the current one
set hls       " highlights search results
set smd       " show vim mode on status bar
set ls=2      " always show status bar at the bottom
set nowrap    " disables line wrap (display only)
set tw=0      " disables text wrap (actual \n inserted)

set cursorline      " highlights the cursor line
set cursorcolumn    " highlights the cursor column
set signcolumn=yes  " gutter always visible

" This is a centered thin horizontal bar that works well for tab: '𝄖' ;
set listchars=eol:𝆨,tab:𝄅\ \ ,trail:·,extends:⇒,precedes:⇐
set list

" underline, reverse removed
augroup ruler_hl
    autocmd BufEnter * highlight OverLength cterm=bold ctermfg=None
    autocmd BufEnter * match OverLength /\%80v.*/
    autocmd BufEnter * highlight SuperOverLength cterm=bold,italic ctermfg=None
    autocmd BufEnter * 2match SuperOverLength /\%110v.*/
augroup END

" -------------------------------input configs------------------------------- "
nnoremap <SPACE> <Nop>
nnoremap ; <Nop>
let mapleader=" "
let maplocalleader=";"

" ------------------------------------ - ------------------------------------ "

au! BufNewFile,BufRead *.svelte set ft=html

" Remember cursor line of closed files. See :help last-position-jump
autocmd BufReadPost *
\ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
\ |   exe "normal! g`\""
\ | endif

" For some reason, nvim gets slow AF when opening .py files without this:
let g:python_host_prog  = 'python2'  " change to '/usr/bin/python2' if needed
let g:python3_host_prog = 'python3'  " change to '/usr/bin/python3' if needed
" Old fix for the above:
let g:python_host_skip_check = 1
let g:python3_host_skip_check = 1
  '';

  # Basic tmux configuration
  environment.etc."tmux.conf".text = ''
# By default, tmux starts login shells. This disables that
set -g default-command "''${SHELL}"

# Mouse
set -g mouse on

#set -g set-titles on
#set -g set-titles-string "#W"

# Colors
set -g default-terminal "screen-256color"
set -ag terminal-overrides ",alacritty:RGB"

# Esc key shorter wait for shortcuts
set -sg escape-time 10

# Makes is easier for vim to detect file changes when run in tmux
set -g focus-events on

# Window name automatically changes to '[session name]: cwd $ current command'
set -g set-titles on
set -g set-titles-string "[#S]: #{s|^$HOME|~|:pane_current_path} $ #W"

# -------------------------------- Keybinds -------------------------------- #

# Unbind default prefix and set it to ctrl-a
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# Window splitting shortcuts that keeps the cwd
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"

# Shortcut to reload tmux conf
bind r source-file ~/.config/tmux/tmux.conf \; display "tmux config reloaded!"

# Easier navigation, yanking, etc
set-window-option -g mode-keys vi
  '';

  # Create necessary directory structure
  system.activationScripts.neovimSetup = {
    deps = [];
    text = ''
      mkdir -p /var/lib/jenkins/.config/nvim
      cp /etc/nvim/init.vim /var/lib/jenkins/.config/nvim/init.vim
      chown -R jenkins:jenkins /var/lib/jenkins/.config/nvim
    '';
  };
}