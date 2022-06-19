local status_ok, trim = pcall(require, "trim")
if not status_ok then
    return
end

trim.setup{
    disable = {},
    patterns = {
        [[%s/\s\+$//e]],           -- remove unwanted spaces
        [[%s/\($\n\s*\)\+\%$//]],  -- trim last line
        [[%s/\%^\n\+//]],          -- trim first line
        [[%s/\(\n\n\)\n\+/\1/]],   -- replace multiple blank lines with a single line
    },
}
