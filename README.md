A simple plugin for displaying marks in the sign column.

![image](https://github.com/vanaigr/mark-signs.nvim/assets/65824523/b6ede486-0c3c-433a-aab2-e7a940cf2ecf)

# Usage

```lua
vim.opt.signcolumn = 'yes:1' -- optional but recommended

local ms = require('mark-signs')

-- hidden, priority, sign_hl, number_hl, line_hl, cursorline_hl,
ms.mark_number_options ({ priority = 10, sign_hl = 'Comment' })
ms.mark_builtin_options({ priority = 11, sign_hl = 'Comment' })
ms.mark_lower_options  ({ priority = 12, sign_hl = 'Normal', number_hl = 'CursorLineNr' })
ms.mark_upper_options  ({ priority = 13, sign_hl = 'Normal', number_hl = 'CursorLineNr' })
ms.mark_options('.', { hidden = true })

if MarksTimer then MarksTimer:stop() end
MarksTimer = vim.uv.new_timer()
MarksTimer:start(0, 400, vim.schedule_wrap(ms.update_marks))
```

# Acknowledgements

[marks.nvim](https://github.com/chentoast/marks.nvim)

[vim-signature](https://github.com/kshenoy/vim-signature)
