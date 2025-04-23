# dynu/fields.nu
export use constants.nu [is_debug_fields]
export use tables.nu [get_current_table_name, table_name, get_current_table_path]
export use core.nu [core_add_field, core_remove_field]

# Function to list field names in the current table (l is for list, fds is for fields)
export def "l fds" [] {
    if $is_debug_fields { print $"Debug: Getting field names for table (table_name) at path (get_current_table_path)" }
    if not ((get_current_table_path) | path exists) {
        error make {msg: $"Error: Table file not found at (get_current_table_path)"}
    }
    if $is_debug_fields { print "Debug: Table file exists, proceeding" }
    let field_names = (open --raw (get_current_table_path) | from json | columns | sort)
    if $is_debug_fields { print $"Debug: Field names: ($field_names)" }
    $field_names
}

# Function to add a new field to the current table (a is for add, fd is for field)
export def "a fd" [field: string] {
    if $is_debug_fields { print $"Debug: Adding field ($field) to table (table_name) at path (get_current_table_path)" }
    if ($field | is-empty) {
        error make {msg: "Error: Field name must not be empty"}
    }
    if not ((get_current_table_path) | path exists) {
        error make {msg: $"Error: Table file not found at (get_current_table_path)"}
    }
    let table = open --raw (get_current_table_path) | from json
    let updated = (core_add_field $table $field)
    $updated | to json --raw | save (get_current_table_path) -f
    echo $"Added field ($field) to table (table_name)"
}

# Function to remove a field from the current table (d is for delete, fd is for field)
export def "d fd" [field: string] {
    if $is_debug_fields { print $"Debug: Removing field ($field) from table (table_name) at path (get_current_table_path)" }
    if ($field | is-empty) {
        error make {msg: "Error: Field name must not be empty"}
    }
    if not ((get_current_table_path) | path exists) {
        error make {msg: $"Error: Table file not found at (get_current_table_path)"}
    }
    let table = open --raw (get_current_table_path) | from json
    if ($field not-in ($table | columns)) {
        error make {msg: $"Error: Field ($field) not found in table"}
    }
    let updated = (core_remove_field $table $field)
    $updated | to json --raw | save (get_current_table_path) -f
    echo $"Removed field ($field) from table (table_name)"
}
