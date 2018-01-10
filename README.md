session
==============================================================================

Simple session management plugin for Vim/Neovim.


Usage
------------------------------------------------------------------------------

Save a session with `SessionSave` command:

```vim
:SessionSave
" Save a current session as a default/current session

:SessionSave {session}
" Save a current session as a given {session} session

:SessionSave!
" Overwrite a current session as a default/current session

:SessionSave! {session}
" Overwrite a current session as a given {session} session
```

Open a session with `SessionOpen` command:

```vim
:SessionOpen
" Open a default/current session

:SessionOpen {session}
" Open a given {session} session

:SessionOpen!
" Open a default/current session even non-saved buffers exist

:SessionOpen! {session}
" Open a given {session} session even non-saved buffers exist
```

Remove a session with `SessionRemove` command:

```vim
:SessionRemove
" Remove a default/current session

:SessionRemove {session}
" Remove a given {session} session
```

Find and manipulate existing sessions with `SessionList` command:

```vim
:SessionList
" Open a session-list window to open/remove existing sessions
" Mappings
" [n] <Return>  - Open a session under the cursor
" [n] g<Return> - Open a session forcedly under the cursor
" [n] dd        - Remove a session under the cursor
" [v] dd        - Remove sessions in the selection

:SessionList {opener}
" Open a session://list window with a given {opener} (e.g. 'split')
```

Close a current session with `SessionClose` command:

```vim
:SessionClose
" Close a current session

:SessionClose!
" Close a current session forcedly even non-saved buffers exist
```

And with [Shougo/deoplete.nvim](https://github.com/Shougo/deoplete.nvim):

```vim
:Denite session
" Actions
" open          - SessionOpen on a selected candidate
" open_force    - SessionOpen! on a selected candidate
" remove        - SessionRemove on a selected candidate
```


Configuration
-------------------------------------------------------------------------

Use the following variables to configure the behavior:

```vim
let g:session_dir = '~/.cache/session.vim'
" A directory path which all session files will be saved/searched

let g:session#default_opener = 'edit'
" Used when no {opener} is given to SessionList command

let g:session#default_session = 'default'
" Used when no {session} is given and v:this_session is empty (session has not been loaded)

let g:session#default_mappings = 1
" Set it to 0 if you don't need default mappings on session://list window.
" Use the followings to define your custom mappings in that case:
" [n] <Plug>(session-open)          Perform SessionOpen on a session under the cursor
" [n] <Plug>(session-open-force)    Perform SessionOpen on a session under the cursor
" [n] <Plug>(session-remove)        Perform SessionRemove on a session under the cursor
" [v] <Plug>(session-remove)        Perform SessionRemove on sessions in the selection
```
