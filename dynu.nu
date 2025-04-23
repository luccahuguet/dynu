# dynu/dynu.nu
export use constants.nu [is_debug_dynu]
export use fields.nu ["l fds", "a fd", "d fd"]  # Exports for field commands
export use tables.nu ["a tb", "l tbs", "d tb", "s tb"]  # Exports for table commands
use tables.nu [table_name, get_current_table_path]
use core.nu [core_add, core_sort_by, core_remove_at, core_update_at, core_purge]
use utils.nu [apply_color]


# Function to add a new item to the current dynu table (a is for add)
export def a [field: string, value: string] {
    if $is_debug_dynu { print $"Debug: Adding element to table (table_name) at path (get_current_table_path)" }
    if ($field | is-empty) or ($value | is-empty) {
        error make {msg: "Error: Field and value must not be empty"}
    }
    let element = { ($field): $value }
    # Read current elements
    let table = els
    let updated_table = (core_add $table $element)
    if $is_debug_dynu { print $"Debug: Final table: ($updated_table)" }
    print $"Element added to table (table_name)"
    save_sort_show $updated_table "name"
}

# Function to read the current dynu table from the file (internal, not user-facing)
def els [--show] {
    if $is_debug_dynu { print "Debug: Listing current dynu table items" }
    if $is_debug_dynu { print $"Debug: Reading table (table_name) from path (get_current_table_path)" }
    if not (get_current_table_path | path exists) {
        error make {msg: $"Error: Table file not found at (get_current_table_path)"}
    }
    let table_data = (get_current_table_path) | open
    $table_data
}

# Function to edit an item in the current dynu table by index and field (e is for edit)
export def "e el" [elm_idx: number, field: string, value: string] {
    if $is_debug_dynu { print $"Debug: Editing element at index ($elm_idx) in table (table_name) at path (get_current_table_path)" }
    if ($elm_idx | is-not-number) or ($field | is-empty) or ($value | is-empty) {
        error make {msg: "Error: Invalid index, field, or value provided"}
    }
    let table = els
    if $elm_idx >= ($table | length) {
        error make {msg: $"Error: Index ($elm_idx) out of bounds"}
    }
    # Retrieve existing element by index
    let element = ($table | get $elm_idx)
    # Update only the specified field (merge overrides existing field)
    let updated_record = ($element | merge {($field): $value})
    let updated_table = (core_update_at $table $elm_idx $updated_record)
    if $is_debug_dynu { print $"Debug: Updated table: ($updated_table)" }
    print $"Element at index ($elm_idx) updated in table (table_name)"
    save_sort_show $updated_table "name"
}

# Internal helper: sort, save, and show table (internal, not user-facing)
def save_sort_show [table: table, field: string] {
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

# Function to remove an item from the current dynu table by index (d is for delete)
export def "d el" [elm_idx: number] {
    if $is_debug_dynu { print $"Debug: Removing element at index ($elm_idx) from table (table_name) at path (get_current_table_path)" }
    if ($elm_idx | is-not-number) {
        error make {msg: "Error: Invalid index provided"}
    }
    let table = els
    if $elm_idx >= ($table | length) {
        error make {msg: $"Error: Index ($elm_idx) out of bounds"}
    }
    let updated_table = (core_remove_at $table $elm_idx)
    save_sort_show $updated_table "grade"
}

# Function to purge the current dynu table (p is for purge)
export def "p tb" [] {
    if $is_debug_dynu { print $"Debug: Purging table (table_name) at path (get_current_table_path)" }
    let table = els
    let updated_table = (core_purge $table)
    # Save the empty table as JSON
    # Save the empty table (auto-detect JSON based on extension)
    # Serialize empty table to JSON and save
    $updated_table | to json --raw | save (get_current_table_path) -f
}

export def main [] {
    print (ls tbs)
    print $"Current table: (table_name)"
}


# Aliases for testing (snake_case)
# Removed old aliases: edit_elm, rm_elm; use short commands (a, e el, d el, p tb)
