---@class (exact) Table
---@field size [number, number]
---@field ccol number
---@field crow number
---@field data number[][]
local Table = {}

---@type Table[]
local tables = {}
---@type number
local current_table = nil

-- TODO redo with tonumber() or ...

---@param t Table
function TablePrint(t)
 io.write(string.format("table #%d (%dx%d)\n", current_table, t.size[1], t.size[2]))
  for _,r in pairs(t.data) do
    for _,c in pairs(r) do
      io.write(c)
      io.write(" ")
    end
    print()
  end
end

---@param t Table
---@param rows number
---@param cols number
function TableResize(t, rows, cols)
  t.size[1] = math.max(cols, t.size[1])
  t.size[2] = math.max(rows, t.size[2])
  for i=1,t.size[2] do
    t.data[i] = t.data[i] or {}
    for j=1,t.size[1] do
      t.data[i][j] = t.data[i][j] or 0
    end
  end
end

local errNoTable = "[ERROR] no table"
local errRangeArgs = "[ERROR] unvalid args for range"

---@param obj string
function New(obj, ...)
  local args = {...}
  if obj == "table" then
    table.insert(tables, {
      size = {0, 0},
      ccol = 0, crow = 0,
      data = {{}}
    })
    current_table = #tables
  elseif obj == "col" then
    if current_table == nil then print(errNoTable) return end
    if args[1] == "range" then
      if #args < 3 then print(errRangeArgs) return end
      local rstart = tonumber(args[2])
      local rend = tonumber(args[3])
      if rstart == nil then print(errRangeArgs) return end
      if rend == nil then print(errRangeArgs) return end
      if rstart > rend then print(errRangeArgs) return end

      TableResize(tables[current_table], rend-rstart+1, 1+tables[current_table].size[1])
      tables[current_table].ccol = tables[current_table].size[1]

      local col = tables[current_table].ccol
      for i=1,rend do
        tables[current_table].data[i][col] = rstart+i-1
      end
    elseif args[1] == "func" then
      if #args == 1 then print("[ERROR] expected argument for func") return end
      local func = args[2]
      for i,w in pairs(args) do
        if i > 2 then
          func = func .. " " .. w
        end
      end
      func = "return function(row, col, tab, tables, current_table) " .. func .. " end"
      local _f,_ = load(func)
      if _f then
        local ok, f = pcall(_f)
        if ok then
          TableResize(tables[current_table], tables[current_table].size[2], 1+tables[current_table].size[1])
          tables[current_table].ccol = tables[current_table].size[1]

          local col = tables[current_table].ccol
          for i=1,tables[current_table].size[2] do
            tables[current_table].data[i][col] = f(i, col, tables[current_table], tables, current_table)
          end
        end
      end
    else
      print("[ERROR] unknown method")
    end
  else
    print("[ERROR] unknown obj")
  end
end


function Show()
  if current_table == nil then print(errNoTable) return end
  TablePrint(tables[current_table])
end

local help = [[
Comands:
q | quit | exit   quit
h | help | ?      print help
]]

while true do
  io.write("> ")
  local input = io.read()
  local func = ""
  local i = 0
  if input == "q" or input == "quit" or input == "exit" then
    break
  elseif input == "help" or input == "h" or input == "?" then
    io.write(help)
  elseif input ~= "" then
    for w in input:gmatch("%S+") do
      if i == 0 then
        func = func .. w:gsub("^%l", string.upper) .. "("
      elseif i == 1 then
        func = func .. "\"" .. w .. "\""
      else
        func = func .. ", \"" .. w .. "\""
      end
      i = i + 1
    end
    func = func .. ")"
    local f = load(func)
    if f then
      f()
    else
      print("[ERROR] cannot run " .. func)
    end
  end
end

