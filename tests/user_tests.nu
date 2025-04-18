#!/usr/bin/env nu

# Integration tests emulating a user for dynu CLI

# Stub input for interactive commands
let TEST_INPUTS = ["field1" "value1" "val1" "edited1"]
let CALL_INDEX = 0
def input [prompt: string] {
    let idx = ($CALL_INDEX | into int)
    let val = ($TEST_INPUTS | get idx)
    let CALL_INDEX = ($CALL_INDEX + 1)
    echo $val
}

# Helper for test failures
def fail [msg: string] {
    echo "ERROR: $msg"
    exit 1
}

# Source project modules
source ../constants.nu
source ../core.nu
source ../tables.nu
source ../fields.nu
source ../dynu.nu

echo "Testing table commands..."

# 1. Initial ls tables
let init = ("ls tables")
if not ($init | str contains "Existing tables") { fail "ls tables initial did not display header" } else { echo "ls tables initial passed" }

# 2. Add table 'tbl'
let added = ("add table" "tbl")
if ($added != "tbl") { fail "add table returned unexpected name: $added" } else { echo "add table passed" }

# 3. ls tables shows 'tbl'
let after_ls = ("ls tables")
if not ($after_ls | str contains "tbl") { fail "ls tables did not list tbl after add" } else { echo "ls tables after add passed" }

echo "Testing field commands..."

# 4. Add field 'newfield'
("add field" "newfield")
let fields1 = ("ls fields")
if not ($fields1 | str contains "newfield") { fail "add field failed" } else { echo "add field passed" }

# 5. Remove field 'newfield'
("rm field" "newfield")
let fields2 = ("ls fields")
if ($fields2 | str contains "newfield") { fail "rm field failed" } else { echo "rm field passed" }

echo "Testing dynu element commands..."

# 6. Add element
add
let data1 = (($env.HOME + "/.dynu/tbl_dynu.nuon") | open)
if ($data1 | length) != 2 { fail "add element failed, expected 2 rows" } else { echo "add element passed" }

# 7. Edit element at index 1
"edit elm" 1
let edited = (($env.HOME + "/.dynu/tbl_dynu.nuon") | open)
if ( ($edited | get 1 | get field1) != "edited1" ) { fail "edit elm failed" } else { echo "edit elm passed" }

# 8. Remove element at index 0
"rm elm" 0
let data2 = (($env.HOME + "/.dynu/tbl_dynu.nuon") | open)
if ($data2 | length) != 1 { fail "rm elm failed, expected 1 row" } else { echo "rm elm passed" }

# 9. Purge elements
purge
let data3 = (($env.HOME + "/.dynu/tbl_dynu.nuon") | open)
if ($data3 | length) != 0 { fail "purge failed, expected 0 rows" } else { echo "purge passed" }

echo "Testing table removal..."

# 10. Remove table 'tbl'
"rm table" "tbl"
if (($env.HOME + "/.dynu/tbl_dynu.nuon") | path exists) { fail "rm table failed, file still exists" } else { echo "rm table passed" }

echo "User integration tests passed"