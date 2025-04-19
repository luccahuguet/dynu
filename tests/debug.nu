#!/usr/bin/env nu

# Debug script to step through Test 3 of dynu integration tests
let cwd = (pwd)
$env.HOME = $cwd + "/tests/tmp_home"
# Reset test home
rm --recursive --force $env.HOME
mkdir $env.HOME

source ../constants.nu
source ../core.nu
source ../tables.nu
source ../fields.nu
source ../dynu.nu

alias ls_tables = list
alias add_table = add table
alias rm_table = rm table
alias edit_elm = e elm
alias rm_elm = rm elm

print "[After init]"
let init = (ls_tables)
print $init

print "[add_table tbl field1 value1]"
let _ = add_table tbl field1 value1

print "[ls_tables after add]"
let after = (ls_tables)
print $after

print "[add_field newfield]"
add_field newfield
print "[fields]"
let fields1 = (ls_fields | str join "\n")
print $fields1
print "[rm_field newfield]"
rm_field newfield
print "[fields2]"
let fields2 = (ls_fields | str join "\n")
print $fields2

print "[Test3 Step6 - data_before]"
let data_before = (($env.HOME + "/.dynu/tbl_dynu.json") | open)
print "[raw json before]"
let raw_before = (($env.HOME + "/.dynu/tbl_dynu.json") | open --raw)
print $raw_before
print ($data_before | length)

print "[add field1 val1]"
add field1 val1

print "[data1]"
let data1 = (($env.HOME + "/.dynu/tbl_dynu.json") | open)
print ($data1 | length)

print "[edit_elm 1 edited1]"
edit_elm 1 edited1

print "[edited file]"
let edited = (($env.HOME + "/.dynu/tbl_dynu.json") | open)
print $edited
print "[get edited[1].field1]"
print ($edited | get 1 | get field1)

print "[rm_elm 0]"
rm_elm 0
print "[data2]"
let data2 = (($env.HOME + "/.dynu/tbl_dynu.json") | open)
print ($data2 | length)

print "[purge]"
purge
print "[data3]"
let data3 = (($env.HOME + "/.dynu/tbl_dynu.json") | open)
print ($data3 | length)
