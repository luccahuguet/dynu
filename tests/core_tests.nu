#!/usr/bin/env nu

# core function tests for dynu/core.nu
source ../core.nu
use ../utils.nu [apply_color]

# Helper function for error exit
def fail [msg: string] {
    echo $msg
    exit 1
}

# Test data
let table = [ {a: 1}, {a: 3}, {a: 2} ]

## core_add
let added = (core_add $table {a: 4})
if ($added | length) != 4 { fail "core_add failed: expected length 4, got ($($added | length))" } else { echo (apply_color "green" "[Test 1] core_add passed") }

# core_sort_by ascending
let sorted = (core_sort_by $table "a" false)
if (($sorted | get 0 | get a) != 1) { fail "core_sort_by asc failed at index 0" } else { echo (apply_color "green" "[Test 2] core_sort_by asc index 0 passed") }
if (($sorted | get 2 | get a) != 3) { fail "core_sort_by asc failed at index 2" } else { echo (apply_color "green" "[Test 3] core_sort_by asc index 2 passed") }

# core_sort_by descending
let sorted_desc = (core_sort_by $table "a" true)
if (($sorted_desc | get 0 | get a) != 3) { fail "core_sort_by desc failed" } else { echo (apply_color "green" "[Test 4] core_sort_by desc passed") }

# core_remove_at
let removed = (core_remove_at $table 1)
if ($removed | length) != 2 { fail "core_remove_at failed: expected length 2, got ($($removed | length))" }
if (($removed | get 1 | get a) != 2) { fail "core_remove_at failed: incorrect element at index 1" } else { echo (apply_color "green" "[Test 5] core_remove_at passed") }

# core_update_at
let updated = (core_update_at $table 1 {a: 99})
if (($updated | get 1 | get a) != 99) { fail "core_update_at failed" } else { echo (apply_color "green" "[Test 6] core_update_at passed") }

# core_purge
let purged = (core_purge $table)
if ($purged | length) != 0 { fail "core_purge failed: expected empty table" } else { echo (apply_color "green" "[Test 7] core_purge passed") }

# core_add_field
let ftable = [ {a: 1}, {a: 2} ]
let fadded = (core_add_field $ftable "b")
if (($fadded | get 0 | get b) != null) { fail "core_add_field failed: expected null field" } else { echo (apply_color "green" "[Test 8] core_add_field passed") }

# core_remove_field
let fremoved = (core_remove_field $fadded "a")
if ("a" in ($fremoved | get 0 | columns)) { fail "core_remove_field failed: field 'a' still present" } else { echo (apply_color "green" "[Test 9] core_remove_field passed") }

echo (apply_color "cyan" "[All core.nu tests passed]")
