---@param str string
---@return string
local function trim (str)
    local result = str:gsub("^%s+", ""):gsub("%s+$", "")
    return result
end

---@param str string
---@return string
local function collapseSpaces (str)
    local result = str:gsub("%s+", " ")
    return result
end

---@param str string
---@param char string
---@return fun(): string | nil
local function splitByChar (str, char)
    return str:gmatch("([^" .. char .. "]*)")
end

---@type string[][]
local worksheetRaw = {}
for line in io.stdin:lines("*l") do
    local row = {}
    for cel in splitByChar(collapseSpaces(trim(line)), " ") do
        table.insert(row, cel)
    end
    table.insert(worksheetRaw, row)
end

---@type { items: string[], operator: string }[]
local worksheet = {}

for i = 1, #worksheetRaw[1] do
    table.insert(worksheet, {
        items = {},
        operator = worksheetRaw[#worksheetRaw][i],
    })
end

for i = 1, #worksheetRaw - 1 do
    for j, v in ipairs(worksheetRaw[i]) do
        table.insert(worksheet[j].items, tonumber(v))
    end
end

local sum = 0
for _, problem in ipairs(worksheet) do
    local result = 0
    if problem.operator == "*" then
        result = 1
    end

    for _, v in ipairs(problem.items) do
        if problem.operator == "+" then
            result = result + v
        else
            result = result * v
        end
    end

    sum = sum + result
end

print(sum)
