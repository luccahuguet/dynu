# dynu/dynu.nu
export use constants.nu [is_debug_dynu]
export use fields.nu ["ls fields", "add field", "rm field"]
export use tables.nu ["add table", "list", "rm table", "set table"]
use tables.nu [table_name, get_current_table_path]
export use core.nu [core_add, core_sort_by, core_remove_at, core_update_at, core_purge]

export def apply_color [color: string, str: string] { $"(ansi $color)($str)(ansi reset)" }


# Define a function to add a new item to the current dynu table without interactive input
export def add [field: string, value: string] {
    if $is_debug_dynu { print $"Debug: Adding element to table (table_name) at path (get_current_table_path)" }
    let element = { ($field): $value }
    # Read current elements
    let table = els
    let updated_table = (core_add $table $element)
    if $is_debug_dynu { print $"Debug: Final table: ($updated_table)" }
    print $"Element added to table (table_name)"
    save_sort_show $updated_table "name"
}

# Define a function to read the current dynu table from the file
export def els [--show] {
    if $is_debug_dynu { print "Debug: Listing current dynu table items" }
    if $is_debug_dynu { print $"Debug: Reading table (table_name) from path (get_current_table_path)" }
    let table_data = (get_current_table_path) | open
    $table_data
}

# Define a function to edit an item in the current dynu table by index and field
export def "edit elm" [elm_idx: number, field: string, value: string] {
    if $is_debug_dynu { print $"Debug: Editing element at index ($elm_idx) in table (table_name) at path (get_current_table_path)" }
    let table = els
    # Retrieve existing element by index
    let element = ($table | get $elm_idx)
    # Update only the specified field (merge overrides existing field)
    let updated_record = ($element | merge {($field): $value})
    let updated_table = (core_update_at $table $elm_idx $updated_record)
    if $is_debug_dynu { print $"Debug: Updated table: ($updated_table)" }
    print $"Element at index ($elm_idx) updated in table (table_name)"
    save_sort_show $updated_table "name"
}

export def save_sort_show [table: table, field: string] {
    if $is_debug_dynu { print $"Debug: Sorting table by field ($field)" }
    let sorted = (core_sort_by $table $field true)
    if $is_debug_dynu { print $"Debug: Sorted table: ($sorted)" }
    # Save the sorted table as a list of records in JSON format
    # Collect the table into a single list of records and save in JSON format
    # Use JSON as it cleanly serializes lists of records; JSON is valid Nuon
    # Save the sorted table (auto-detect JSON based on extension)
    # Serialize sorted table to JSON and save
    $sorted | to json --raw | save (get_current_table_path) -f
    els --show
}

# Define a function to remove an item from the current dynu table by index
export def "rm elm" [elm_idx: number] {
    if $is_debug_dynu { print $"Debug: Removing element at index ($elm_idx) from table (table_name) at path (get_current_table_path)" }
    let table = els
    let updated_table = (core_remove_at $table $elm_idx)
    save_sort_show $updated_table "grade"
}

# Define a function to purge the current dynu table
export def purge [] {
    if $is_debug_dynu { print $"Debug: Purging table (table_name) at path (get_current_table_path)" }
    let table = els
    let updated_table = (core_purge $table)
    # Save the empty table as JSON
    # Save the empty table (auto-detect JSON based on extension)
    # Serialize empty table to JSON and save
    $updated_table | to json --raw | save (get_current_table_path) -f
}

export def main [] {
    list
    print $"Current table: (table_name)"
}


# Aliases for testing (snake_case)
alias edit_elm = edit elm
alias rm_elm = rm elm
