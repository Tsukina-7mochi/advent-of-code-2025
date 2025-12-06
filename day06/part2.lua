---@type string[]
local lines = {}
for line in io.stdin:lines("*l") do
    table.insert(lines, line)
end
local opLine = table.remove(lines) --[[ @as string ]]

local sum = 0
local idx = 1
while idx <= #opLine do
    local nextIdx = opLine:find("[+*]", idx + 1)
    if nextIdx == nil then
        -- enurate whitespaces between columns after last column
        nextIdx = #opLine + 2
    end

    local op = opLine:sub(idx, idx)
    local result = 0
    if op == "*" then
        result = 1
    end

    -- ignore whitespace
    for i = idx, nextIdx - 2 do
        local numStr = ""
        for _, l in ipairs(lines) do
            numStr = numStr .. l:sub(i, i)
        end

        numStr = numStr:gsub("%s+", "")
        local num = tonumber(numStr)
        -- print("i: ", i, "str: ", numStr, "num: ", num)

        if op == "+" then
            result = result + num
        else
            result = result * num
        end
    end

    sum = sum + result

    idx = nextIdx
end

print(sum)
