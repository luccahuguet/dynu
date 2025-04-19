# dynu/fields.nu
export use constants.nu [is_debug_fields]
export use tables.nu [get_current_table_name, table_name, get_current_table_path]
    export use core.nu [core_add_field, core_remove_field]




#+ Define a function to get the field names from the current table (shortened: "ls fls")
export def "ls fls" [] {
    if $is_debug_fields { print $"Debug: Getting field names for table (table_name) at path (get_current_table_path)" }
    if not ((get_current_table_path) | path exists) {
        if $is_debug_fields { print "Debug: Table file does not exist" }
        []
    } else {
    # Load and list sorted field names from the current table
    # Load JSON content and list sorted field names
    let field_names = (open --raw (get_current_table_path) | from json | columns | sort)
        if $is_debug_fields { print $"Debug: Field names: ($field_names)" }
        $field_names
    }
}

#+ Define a function to add a new field to the current table (shortened: "a fl")
export def "a fl" [field: string] {
    if $is_debug_fields { print $"Debug: Adding field ($field) to table (table_name) at path (get_current_table_path)" }
    # Read the current table file as JSON
    # Read and parse the current table JSON
    let table = open --raw (get_current_table_path) | from json
    let updated = (core_add_field $table $field)
    # Save the updated table (auto-detect JSON format based on extension)
    # Serialize updated table to JSON and save
    $updated | to json --raw | save (get_current_table_path) -f
    echo $"Added field ($field) to table (table_name)"
}

#+ Define a function to remove a field from the current table (shortened: "d fl")
export def "d fl" [field: string] {
    if $is_debug_fields { print $"Debug: Removing field ($field) from table (table_name) at path (get_current_table_path)" }
    # Read the current table file as JSON
    # Read and parse the current table JSON
    let table = open --raw (get_current_table_path) | from json
    let updated = (core_remove_field $table $field)
    # Save the updated table (auto-detect JSON format based on extension)
    # Serialize updated table to JSON and save
    $updated | to json --raw | save (get_current_table_path) -f
    echo $"Removed field ($field) from table (table_name)"
}
 
# Removed old aliases: ls_fields, add_field, rm_field; use short commands (ls fls, a fl, d fl)
