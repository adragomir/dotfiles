local ts_utils = require "nvim-treesitter.ts_utils"
-- local query = require "nvim-treesitter.query"
-- local configs = require "nvim-treesitter.configs"
-- local parsers = require "nvim-treesitter.parsers"

--nvim_win_set_cursor - line start at 1, col start at 0
--set_pos - line start at 1, col start at 1
--vim.fn.line, vim.fn.col - line start at 1, col start at 1

local M = {}

DEBUG = false
local function debug(obj)
    if DEBUG then
        print(obj)
    end
end

local function flatten(root, results, level )
    level = level or 0
    if results == nil then
        results = {}
        local node_entry = {
            level = level,
            node = root,
            field = nil,
        }
        table.insert(results, node_entry)
    end
    results = results or {}
    for node, field in root:iter_children() do
        local node_entry = {
            level = level,
            node = node,
            field = field,
        }
        table.insert(results, node_entry)
        flatten(node, results, level + 1)
    end
    return results
end

local function dump_node(node, bufnr)
    local srow, scol, erow, ecol = ts_utils.get_vim_range({ node:range() }, bufnr)

    -- soffset is before the cursor
    local srow2, scol2, soffset = unpack({node:start()})
    local erow2, ecol2, eoffset = unpack({node:end_()})
    local node_text = ts_utils.get_node_text(node, bufnr)[1]
    debug(string.format(
        "%d %d %d %d: |%s| (%d %d %d %d - %d %d)", 
        srow, scol, erow, ecol, node_text, 
        srow2, scol2, erow2, ecol2, 
        soffset, eoffset
    ))
end

local function byte_to_row_col(b)
    local dst_line = vim.fn.byte2line(b)
    local dst_col = b - vim.fn.line2byte(dst_line) + 1
    return {dst_line, dst_col}
end

local function row_col_to_byte(row, col)
    return vim.fn.line2byte(row) + col - 1
end

local function set_cursor_at_byte(b)
    debug(string.format("move to: %d", b))
    local dst_line, dst_col = unpack(byte_to_row_col(b))
    vim.fn.setpos('.', {0, dst_line, dst_col})
end

local function move(dir)
    local winnr = vim.api.nvim_get_current_win()
    local bufnr = vim.api.nvim_win_get_buf(winnr)

    local cursor = vim.api.nvim_win_get_cursor(winnr)
    local cursor_range = { cursor[1], cursor[2]+1 }
    local row, col = unpack(cursor_range)

    local start_node = ts_utils.get_node_at_cursor(winnr)
    local row2 = vim.fn.line(".")
    local col2 = vim.fn.col(".")
    local offset = row_col_to_byte(row2, col2)
    local offset0 = offset - 1
    debug(string.format("offset: %d %d", offset, offset0))

    -- find start node
    while true do
        local srow, scol, soffset = unpack({start_node:start()})
        local erow, ecol, eoffset = unpack({start_node:end_()})
        local cond
        if (soffset == offset0) or (eoffset - 1 == offset0) then
            local tmp_start_node = start_node:parent()
            if tmp_start_node then
                start_node = tmp_start_node
            else
                break
            end
        else
            break
        end
    end

    -- get all nodes
    local all_nodes = flatten(start_node, nil, 0)
    debug(string.format("all nodes: %d", #all_nodes))

    -- temp vars
    local smallest_diff = 10000000
    local smallest_move_to_offset = 0
    local closest_node
    local closest_node_mode = ""

    for _, fnode in ipairs(all_nodes) do
        local node = fnode.node
        dump_node(node)

        -- try start
        local tryrow, trycol, tryoffset = unpack({node:start()})
        debug(string.format("  start: %d - %d", tryoffset, offset0))
        local cond
        if dir == 1 then
            cond = (tryoffset < offset0)
        elseif dir == 2 then
            cond = (tryoffset > offset0)
        end
        if cond then
            local diff = math.abs(offset0 - tryoffset)
            if diff < smallest_diff and diff > 0 then
                smallest_diff = diff
                smallest_move_to_offset = tryoffset
                closest_node = node
                closest_node_mode = "s"
            end
        end
        tryrow, trycol, tryoffset = unpack({node:end_()})
        tryoffset = tryoffset - 1
        debug(string.format("  end: %d - %d", tryoffset, offset0))
        if dir == 1 then
            cond = (tryoffset < offset0)
        elseif dir == 2 then
            cond = (tryoffset > offset0)
        end
        if cond then
            local diff = math.abs(offset0 - tryoffset)
            if diff < smallest_diff and diff > 0 then
                smallest_diff = diff
                smallest_move_to_offset = tryoffset
                closest_node = node
                closest_node_mode = "e"
            end
        end
    end
    --vim.api.nvim_win_set_cursor(winnr, {smallest_move_to[1], smallest_move_to[2]-1})
    dump_node(closest_node)
    debug(string.format("mode: %s", closest_node_mode))
    local final_offset = smallest_move_to_offset + 1
    -- if closest_node_mode ~= "e" then
    --     final_offset = final_offset + 1
    -- end
    set_cursor_at_byte(final_offset)
end

-- M.test = function()
--   move()
-- end
M.move = function(dir)
    move(dir)
end
M.byte_to_row_col = byte_to_row_col

return M

