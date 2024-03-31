# dynu/constants.nu

# Define the path to the current table file
export const current_table_path = "~/.current_table.nuon"

# Define a function to get the path to the file for a specified table
export def get_dynu_path [table_name: string] {
    $"~/.($table_name)_dynu.nuon"
}

# Define a function to get the path to the field names file for a specified table
export def get_field_names_path [table_name: string] {
    $"~/.($table_name)_fields.nuon"
}