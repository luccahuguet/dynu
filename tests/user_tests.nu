#!/usr/bin/env nu

# Integration tests for Dynu CLI
use std/assert
use ../utils.nu [apply_color]  # Added to import apply_color function

# Source project modules
source ../constants.nu
source ../core.nu
source ../tables.nu
source ../fields.nu
use ../dynu.nu [a, "e el", "d el", "p tb"]  # Updated to single-letter function names

print (apply_color "blue" "[Test 1] Testing table commands...")

# 1. Initial ls tbs
let init = ("l tbs")  # Updated to single-letter function
assert str contains $init "Existing tables"

# 2. Add table 'tbl' with initial field and value
let added = ("a tb" tbl field1 value1)  # Updated to single-letter function

# 3. ls tbs shows 'tbl'
let after_ls = ("l tbs")  # Updated to single-letter function
assert str contains $after_ls "tbl"

print (apply_color "blue" "[Test 2] Testing field commands...")

# 4. Add field 'newfield'
"a fd" newfield  # Updated to new abbreviation
let fields1 = ("l fds")  # Updated to new abbreviation
let fields1_str = ($fields1 | str join "\n")
assert str contains $fields1_str "newfield"

# 5. Remove field 'newfield'
"d fd" newfield  # Updated to new abbreviation
let fields2 = ("l fds")  # Updated to new abbreviation
let fields2_str = ($fields2 | str join "\n")
assert (not ($fields2_str | str contains "newfield"))

print (apply_color "blue" "[Test 3] Testing Dynu element commands...")

# 6. Add element
let data_before = (($env.HOME + "/.dynu/tbl_dynu.json") | open)
assert equal ($data_before | length) 1
a field1 val1  # Updated to single-letter function
let data1 = (($env.HOME + "/.dynu/tbl_dynu.json") | open)
assert equal ($data1 | length) 2

# 7. Edit element at index 1
"e el" 1 field1 edited1  # Updated to single-letter function
let edited = (($env.HOME + "/.dynu/tbl_dynu.json") | open)
assert equal ($edited | get 1 | get field1) "edited1"

# 8. Remove element at index 0
"d el" 0  # Updated to single-letter function
let data2 = (($env.HOME + "/.dynu/tbl_dynu.json") | open)
assert equal ($data2 | length) 1

# 9. Purge elements
"p tb"  # Updated to single-letter function
let data3 = (($env.HOME + "/.dynu/tbl_dynu.json") | open)
assert equal ($data3 | length) 0

print (apply_color "blue" "[Test 4] Testing table removal...")

# 10. Remove table 'tbl'
"d tb" tbl  # Updated to single-letter function
assert (not (($env.HOME + "/.dynu/tbl_dynu.json") | path exists))

print (apply_color "green" "[All user integration tests passed]")
