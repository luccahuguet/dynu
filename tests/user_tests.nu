#!/usr/bin/env nu

# Integration tests emulating a user for dynu CLI

# Integration tests for dynu CLI
use std/assert


# Source project modules
# Source project modules relative to tests directory
source ../constants.nu
source ../core.nu
source ../tables.nu
source ../fields.nu
use ../dynu.nu [apply_color, add, "e elm", "rm elm", purge]
alias edit_elm = e elm
alias rm_elm = rm elm

print (apply_color "blue" "[Test 1] Testing table commands...")

# 1. Initial ls tables
let init = (ls_tables)
assert str contains $init "Existing tables"

# 2. Add table 'tbl' with initial field and value
let added = (add_table tbl field1 value1)

# 3. ls tables shows 'tbl'
let after_ls = (ls_tables)
assert str contains $after_ls "tbl"

print (apply_color "blue" "[Test 2] Testing field commands...")

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

print (apply_color "blue" "[Test 3] Testing dynu element commands...")

# 6. Add element
let data_before = (($env.HOME + "/.dynu/tbl_dynu.json") | open)
assert equal ($data_before | length) 1
add field1 val1
let data1 = (($env.HOME + "/.dynu/tbl_dynu.json") | open)
assert equal ($data1 | length) 2

# 7. Edit element at index 1
edit_elm 1 field1 edited1
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

print (apply_color "blue" "[Test 4] Testing table removal...")

# 10. Remove table 'tbl'
rm_table tbl
assert (not (($env.HOME + "/.dynu/tbl_dynu.json") | path exists))

print (apply_color "green" "[All user integration tests passed]")
