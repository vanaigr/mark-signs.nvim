local vim = vim

local M = {}

M.ns = vim.api.nvim_create_namespace('MarkSigns')

-- 32 is space (not a mark)
function M.mark2id(name) return name:byte(1) - 32 end

function M.update_mark(mark, extmarks_by_id)
    local create, update

    local mname = mark.mark:sub(2)
    local id = M.mark2id(mname)
    local mpos = mark.pos
    local mline = mpos[2] - 1

    local ext = extmarks_by_id[id]
    if ext then
        ext.seen = true
        update = ext[2] ~= mline -- lines do not match
    else
        create = true
        update = true
    end

    if update then
        -- int overflow in getmarklist()
        local mcol = mpos[3] < 0 and vim.v.maxcol or mpos[3] - 1
        local opts = {
            strict = false, -- for some reason '> returns column > line byte count
            id = id, sign_text = mname,
        }
        vim.api.nvim_buf_set_extmark(0, M.ns, mline, mcol, opts)
    end

    --return create, update
end

function M.__update_marks_unsafe(buf_id)
    local buf = buf_id or vim.api.nvim_win_get_buf(0)

    local marks_g = vim.fn.getmarklist()
    local marks_l = vim.fn.getmarklist(buf)

    local extmarks = vim.api.nvim_buf_get_extmarks(0, M.ns, {0,0}, {-1,-1}, {})
    local extmarks_by_id = {}
    for _, ext in ipairs(extmarks) do
        extmarks_by_id[ext[1]] = ext
    end

    --local total, new, updated = 0
    for _, mark in ipairs(marks_l) do -- only updating current buffer!
        --[[local update, create = ]]M.update_mark(mark, extmarks_by_id)
        --if update then updated = updated + 1 end
        --if create then new = new + 1 end
        --total = total + 1
    end

    for _, mark in ipairs(marks_g) do
        if mark.pos[1] == buf then
            --[[local update, create = ]]M.update_mark(mark, extmarks_by_id)
            --if update then updated = updated + 1 end
            --if create then new = new + 1 end
            --total = total + 1
        end
    end

    local deleted = 0
    for _, ext in ipairs(extmarks) do
        if not ext.seen then
            deleted = deleted + 1
            vim.api.nvim_buf_del_extmark(0, M.ns, ext[1])
        end
    end

    --local e = vim.uv.hrtime()
    --local ms = 1 / 1000
    --print(
    --    string.format("Time: %05.1f %05.1f %05.1f",
    --    (s2 - s) * ms, (e2 - s2) * ms, (e - e2) * ms
    --))

    --I = I + 1
    --print(
    --    'Total: ' .. total,
    --    'New: ' .. new,
    --    'Updated: ' .. updated,
    --    'Deleted: ' .. deleted
    --)
end

function M.update_marks(buf_id)
    return pcall(M.__update_marks_unsafe, buf_id)
end

return M
