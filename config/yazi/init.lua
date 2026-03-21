function Linemode:full_info()
    local perm = self._file.cha:perm() or ""

    local size = self._file:size()
    size = size and ya.readable_size(size) or "-"

    local mtime = math.floor(self._file.cha.mtime or 0)
    if mtime == 0 then
        mtime = ""
    elseif os.date("%Y", mtime) == os.date("%Y") then
        mtime = os.date("%b %d %H:%M", mtime)
    else
        mtime = os.date("%b %d  %Y", mtime)
    end

    return string.format("%s %s %s", perm, size, mtime)
end
