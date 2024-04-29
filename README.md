A simple plugin for displaying marks in the sign column.

![image](https://github.com/vanaigr/mark-signs.nvim/assets/65824523/b6ede486-0c3c-433a-aab2-e7a940cf2ecf)

# Usage

```lua
vim.opt.signcolumn = 'yes:1' -- recommended

local ms = require('mark-signs')

-- hidden, priority, sign_hl, number_hl, line_hl, cursorline_hl
-- ms.mark_number_options ({ hidden = true })
ms.mark_builtin_options({ priority = 10, sign_hl = 'Comment' })
ms.mark_lower_options  ({ priority = 11, sign_hl = 'Normal', number_hl = 'CursorLineNr' })
ms.mark_upper_options  ({ priority = 12, sign_hl = 'Normal', number_hl = 'CursorLineNr' })
ms.mark_options('.', { hidden = true })

local function update()
    -- don't display marks in cmdwin
    if vim.fn.getcmdwintype() ~= '' then return end

    ms.update_marks()
end

if MarkSignsTimer then MarkSignsTimer:stop() end
local timer = vim.uv.new_timer()
MarkSignsTimer = timer

timer:start(0, 400, vim.schedule_wrap(function()
    local ok, msg = pcall(update)
    if not ok then
        timer:stop()
        vim.notify('mark-signs error: '..vim.inspect(msg), vim.log.levels.ERROR, {})
    end
end))
```

# Acknowledgements

[marks.nvim](https://github.com/chentoast/marks.nvim)

[vim-signature](https://github.com/kshenoy/vim-signature)
