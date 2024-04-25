A simple plugin for displaying marks in the sign column.

![image](https://github.com/vanaigr/mark-signs.nvim/assets/65824523/96c8d64e-67b7-4908-a8b7-3f9d7e96fb6c)

# Usage

```lua
vim.opt.signcolumn = 'yes:1' -- optional

local update_marks = require('mark-signs').update_marks

if MarksTimer then MarksTimer:stop() end
MarksTimer = vim.uv.new_timer()
MarksTimer:start(0, 400, vim.schedule_wrap(update_marks))
```

# Acknowledgements

[marks.nvim](https://github.com/chentoast/marks.nvim)

[vim-signature](https://github.com/kshenoy/vim-signature)
