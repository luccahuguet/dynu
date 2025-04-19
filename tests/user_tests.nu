#!/usr/bin/env nu

# Integration tests emulating a user for dynu CLI

# Stub input for interactive commands

# Stub input for interactive commands
let TEST_INPUTS = ["field1" "value1" "val1" "edited1"]
$env.CALL_INDEX = 0
def input [prompt: string] {
    let idx = ($env.CALL_INDEX | into int)
    let val = ($TEST_INPUTS | get $idx)
    $env.CALL_INDEX = ($env.CALL_INDEX + 1)
    echo $val
}
use std/assert


# Source project modules
# Source project modules relative to tests directory
source ../constants.nu
source ../core.nu
source ../tables.nu
source ../fields.nu
source ../dynu.nu

echo "Testing table commands..."

# 1. Initial ls tables
let init = (ls_tables)
assert str contains $init "Existing tables"

# 2. Add table 'tbl'
let added = (add_table tbl)

# 3. ls tables shows 'tbl'
let after_ls = (ls_tables)
assert str contains $after_ls "tbl"

echo "Testing field commands..."

## 4. Add field 'newfield'
add_field newfield
let fields1 = (ls_fields)
let fields1_str = ($fields1 | str join "\n")
assert str contains $fields1_str "newfield"

# 5. Remove field 'newfield'
rm_field newfield
let fields2 = (ls_fields)
let fields2_str = ($fields2 | str join "\n")
assert (not (($fields2_str | str contains "newfield")))

echo "Testing dynu element commands..."

# 6. Add element
add
let data1 = (($env.HOME + "/.dynu/tbl_dynu.json") | open)
assert equal ($data1 | length) 2

# 7. Edit element at index 1
edit_elm 1
let edited = (($env.HOME + "/.dynu/tbl_dynu.json") | open)
assert equal ($edited | get 1 | get field1) "edited1"

# 8. Remove element at index 0
rm_elm 0
let data2 = (($env.HOME + "/.dynu/tbl_dynu.json") | open)
assert equal ($data2 | length) 1

# 9. Purge elements
purge
let data3 = (($env.HOME + "/.dynu/tbl_dynu.json") | open)
assert equal ($data3 | length) 0

echo "Testing table removal..."

# 10. Remove table 'tbl'
rm_table tbl
assert (not (($env.HOME + "/.dynu/tbl_dynu.json") | path exists))

echo "User integration tests passed"