local status_ok, trim = pcall(require, "trim")
if not status_ok then
    return
end

trim.setup{
    ft_blocklist = {},
    patterns = {
        [[%s/\s\+$//e]],           -- remove unwanted spaces
        [[%s/\(\n\n\)\n\+/\1/]],   -- replace multiple blank lines with a single line
    },
    trim_trailing = true,
    trim_last_line = true,
    trim_first_line = true,
}
