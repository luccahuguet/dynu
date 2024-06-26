# dynu/fields.nu
export use constants.nu [is_debug_fields]
export use tables.nu [get_current_table_name, table_name, get_current_table_path]



# Define a function to get the field names from the current table
export def "ls fields" [] {
    if $is_debug_fields { print $"Debug: Getting field names for table (table_name) at path (get_current_table_path)" }
    if not ((get_current_table_path) | path exists) {
        if $is_debug_fields { print "Debug: Table file does not exist" }
        []
    } else {
        let field_names = ((get_current_table_path) | open | columns | sort)
        if $is_debug_fields { print $"Debug: Field names: ($field_names)" }
        $field_names
    }
}

# Define a function to add a new field to the current table
export def "add field" [field: string] {
    if $is_debug_fields { print $"Debug: Adding field ($field) to table (table_name) at path (get_current_table_path)" }
    let table = ((get_current_table_path) | open)
    let new_table = ($table | each { |row| $row | insert $field null })
    $new_table | to nuon | save (get_current_table_path) -f
    echo $"Added field ($field) to table (table_name)"
}

# Define a function to remove a field from the current table
export def "rm field" [field: string] {
    if $is_debug_fields { print $"Debug: Removing field ($field) from table (table_name) at path (get_current_table_path)" }
    let table = ((get_current_table_path) | open)
    let new_table = ($table | each { |row| $row | reject $field })
    $new_table | to nuon | save (get_current_table_path) -f
    echo $"Removed field ($field) from table (table_name)"
}
