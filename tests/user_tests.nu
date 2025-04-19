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
use ../dynu.nu [apply_color, a, "e el", "d el", "purge tb"]
# Removed old aliases: edit_elm, rm_elm; use short commands (a, e el, d el, purge tb)

print (apply_color "blue" "[Test 1] Testing table commands...")

## 1. Initial ls tbs
let init = (ls tbs)
assert str contains $init "Existing tables"

# 2. Add table 'tbl' with initial field and value
let added = (a tb tbl field1 value1)

## 3. ls tbs shows 'tbl'
let after_ls = (ls tbs)
assert str contains $after_ls "tbl"

print (apply_color "blue" "[Test 2] Testing field commands...")

## 4. Add field 'newfield'
a fl newfield
let fields1 = (ls fls)
let fields1_str = ($fields1 | str join "\n")
assert str contains $fields1_str "newfield"

## 5. Remove field 'newfield'
d fl newfield
let fields2 = (ls fls)
let fields2_str = ($fields2 | str join "\n")
assert (not (($fields2_str | str contains "newfield")))

print (apply_color "blue" "[Test 3] Testing dynu element commands...")

## 6. Add element
let data_before = (($env.HOME + "/.dynu/tbl_dynu.json") | open)
assert equal ($data_before | length) 1
## Add element via short command
a field1 val1
let data1 = (($env.HOME + "/.dynu/tbl_dynu.json") | open)
assert equal ($data1 | length) 2

## 7. Edit element at index 1
e el 1 field1 edited1
let edited = (($env.HOME + "/.dynu/tbl_dynu.json") | open)
assert equal ($edited | get 1 | get field1) "edited1"

## 8. Remove element at index 0
d el 0
let data2 = (($env.HOME + "/.dynu/tbl_dynu.json") | open)
assert equal ($data2 | length) 1

## 9. Purge elements
purge tb
let data3 = (($env.HOME + "/.dynu/tbl_dynu.json") | open)
assert equal ($data3 | length) 0

print (apply_color "blue" "[Test 4] Testing table removal...")

## 10. Remove table 'tbl'
d tb tbl
assert (not (($env.HOME + "/.dynu/tbl_dynu.json") | path exists))

print (apply_color "green" "[All user integration tests passed]")
