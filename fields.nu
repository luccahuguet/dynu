# dynu/fields.nu
export use constants.nu [get_dynu_path]
export use tables.nu [get_current_table]

# Define a function to get the field names from the current table
export def get_field_names [] {
    let table_name = (get_current_table)
    let dynu_path = (get_dynu_path $table_name)
    if not ($dynu_path | path exists) {
        []
    } else {
        open $dynu_path | columns | sort
    }
}

# Define a function to add a new field to the current table
export def "add field" [field: string] {
    let table_name = (get_current_table)
    let dynu_path = (get_dynu_path $table_name)
    let table = (open $dynu_path)
    let new_table = ($table | each { |row| $row | insert $field null })
    $new_table | to nuon | save $dynu_path -f
    echo $"Added field ($field) to table ($table_name)"
}

# Define a function to remove a field from the current table
export def "rm field" [field: string] {
    let table_name = (get_current_table)
    let dynu_path = (get_dynu_path $table_name)
    let table = (open $dynu_path)
    let new_table = ($table | each { |row| $row | reject $field })
    $new_table | to nuon | save $dynu_path -f
    echo $"Removed field ($field) from table ($table_name)"
}