# Table

A simple cli tool to create "EXCEL" tables through a REPL

## Commands
- `new <obj> <method>`: to create a new `obj` (with `method`) and select it
- `select <obj> <int>`: to select an `obj` (starting from 1)
- `fill <obj> <method>`: to fill the `obj` selected with `method`
- `show`: to print the selected table

### Objects
- `table`
- `col`
- `row` 

### Method
- `range <int> <int>`: range from start to end (if col/row too large the rest il filled with 0s)
- `func <func-body>`: generate values using the function `function(row, col, tab, tables, current_table) <func-body> end` in [LUA](https://www.lua.org/)
    `row` and `col` are the coordinates of the cell
    `tab` is the current table with fields `size`, `ccol`, `crow` (the selected col and row), and `data` (the actual 2D array)
    `tables` and `current_table` are the array of all the tables and the index of the current one

## TODOs
- [ ] fill table
