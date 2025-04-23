# dynu/fields.nu
export use constants.nu [is_debug_fields]
export use tables.nu [get_current_table_name, table_name, get_current_table_path]
export use core.nu [core_add_field, core_remove_field]

# Define a function to list field names in the current table (shortened: "ls fls")
export def "ls fls" [] {
    if $is_debug_fields { print $"Debug: Getting field names for table (table_name) at path (get_current_table_path)" }
    if not ((get_current_table_path) | path exists) {
        if $is_debug_fields { print "Debug: Table file does not exist" }
        []
    } else {
        let field_names = (open --raw (get_current_table_path) | from json | columns | sort)
        if $is_debug_fields { print $"Debug: Field names: ($field_names)" }
        $field_names
    }
}

# Define a function to add a new field to the current table (shortened: "a fl")
export def "a fl" [field: string] {
    if $is_debug_fields { print $"Debug: Adding field ($field) to table (table_name) at path (get_current_table_path)" }
    let table = open --raw (get_current_table_path) | from json
    let updated = (core_add_field $table $field)
    $updated | to json --raw | save (get_current_table_path) -f
    echo $"Added field ($field) to table (table_name)"
}

# Define a function to remove a field from the current table (shortened: "d fl")
export def "d fl" [field: string] {
    if $is_debug_fields { print $"Debug: Removing field ($field) from table (table_name) at path (get_current_table_path)" }
    let table = open --raw (get_current_table_path) | from json
    let updated = (core_remove_field $table $field)
    $updated | to json --raw | save (get_current_table_path) -f
    echo $"Removed field ($field) from table (table_name)"
}
