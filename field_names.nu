# dynu/field_names.nu
# Define the path to the field names file
export const field_names_path = "~/.field_names.nuon"

# Define a function to save the field names to the file
export def save_field_names [field_names: list] {
    $field_names | to nuon | save $field_names_path -f
}

# Define a function to read the field names from the file or create it with initial value
export def load_field_names [] {
    if not ($field_names_path | path exists) or (open $field_names_path | is-empty ) {
        ['name'] | to nuon | save $field_names_path -f
        print $"Field names file created"
    }
    open $field_names_path
}

# Define a function to add a new field to the field names
export def "add field" [field: string] {
    let field_names = (load_field_names)
    let new_field_names = ($field_names | append $field)
    save_field_names $new_field_names
    echo $"Added field ($field)"
}

# Define a function to remove a field from the field names
export def "rm field" [field: string] {
    let field_names = (load_field_names)
    let new_field_names = ($field_names | where $it != $field)
    save_field_names $new_field_names
    echo $"Removed field ($field)"
}