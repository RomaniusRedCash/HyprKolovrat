monitosList = {
    [0] = "DVI-I-1",
    [1] = "HDMI-A-1",
    [2] = "DP-1",
}

for i, mon in pairs(monitosList) do
    hl.monitor({
        output = mon,
        mode = "preferred",
        position = 1920 * i .. "x0",
        scale = 1,
    })
end

for i, mon in pairs(monitosList) do
    for j = 1,10 do
        hl.workspace_rule({ workspace = tostring(i * 10 + j), monitor = mon, persistent = true })
    end
end
