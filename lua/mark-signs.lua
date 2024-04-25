local vim = vim

local M = {}

M.ns = vim.api.nvim_create_namespace('MarkSigns')
M.__marks = {}

function M.clear(buf_id)
    vim.api.nvim_buf_clear_namespace(0, M.ns, 0, -1)
end

-- 32 is space (not a mark)
function M.__mark2id(name) return name:byte(1) - 32 end

function M.__compile_options(opts)
    local result = {
        opts.hidden and true,
        opts.priority,
        opts.sign_hl,
        opts.number_hl,
        opts.line_hl,
        opts.cursorline_hl,
    }
    return result
end

function M.mark_lower_options(opts)
    opts = M.__compile_options(opts)
    for i = M.__mark2id('a'), M.__mark2id('z') do
        M.__marks[i] = opts
    end
end

function M.mark_upper_options(opts)
    opts = M.__compile_options(opts)
    for i = M.__mark2id('A'), M.__mark2id('Z') do
        M.__marks[i] = opts
    end
end

function M.mark_number_options(opts)
    opts = M.__compile_options(opts)
    for i = M.__mark2id('0'), M.__mark2id('9') do
        M.__marks[i] = opts
    end
end

-- hopefully all of them (` and ' are same)
M.__builtin_mark_names = vim.split([==[<>[]"'.^]==], '')
function M.mark_builtin_options(opts)
    opts = M.__compile_options(opts)
    for _, name in ipairs(M.__builtin_mark_names) do
        M.__marks[M.__mark2id(name)] = opts
    end
end

function M.mark_options(name, opts)
    M.__marks[M.__mark2id(name)] = M.__compile_options(opts)
end

function M.update_mark(mark, extmarks_by_id)
    local create, update

    local mname = mark.mark:sub(2)
    local id = M.__mark2id(mname)

    local mark_opts = M.__marks[id]
    if not mark_opts or mark_opts[1] then return end

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

            priority = mark_opts[2],
            sign_hl_group = mark_opts[3],
            number_hl_group = mark_opts[4],
            line_hl_group = mark_opts[5],
            cursorline_hl_group = mark_opts[6],
        }

        vim.api.nvim_buf_set_extmark(0, M.ns, mline, mcol, opts)
    end

    --return create, update
end

function M.update_marks(buf_id)
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

return M
