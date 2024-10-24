export use constants.nu [ current_table_path_store_file, is_debug_tables, dynu_dir]

# Returns the path of the current table file
export def get_current_table_path [] {
    let table_name = get_current_table_name
    $"($dynu_dir)/($table_name)_dynu.nuon"
}

# Alias for get_current_table_name
export def table_name [] {get_current_table_name}

# Creates a new table with an initial field and value
export def add_table [new_table_name: string] { 
    if not ($"($dynu_dir)/($new_table_name).nuon" | path exists) {
        let field_name = (input "Enter the name of the field: ")
        let field_value = (input "Enter the value for the field: ")
        let initial_data = ({$field_name: $field_value} | to nuon)
        $initial_data | save $"($dynu_dir)/($new_table_name)_dynu.nuon" -f
        set_current_table $new_table_name
        $new_table_name
    } else {
        $new_table_name
    }
}

# Retrieves all table names from the dynu directory
export def get_table_names [] {
    let dynu_filenames = (glob $"($dynu_dir)/*.nuon" | where ($it | str ends-with "_dynu.nuon"))
    if ($dynu_filenames | is-empty) {
        []
    } else {
        $dynu_filenames | each { |filename|
            let table_name: string = ($filename | parse "/home/lucca/.dynu/{name}_dynu.nuon" | get name | get 0)
            {name: $table_name}
        }
    }
}

# Displays the names of all existing tables
export def display_table_names [tables: table] {
    print $"Existing tables: "
    print ($tables | table)
}

# Ensures a current table exists, creating one if necessary
export def ensure_current_table [] {
    let tables = (get_table_names)
    if ($tables | is-empty) {
        print "No tables found. Please create a new table."
        let new_table_name = (input "Enter the name of the new table: ")
        add_table $new_table_name
    } else {
        let current_table = (table_name)
        if ($current_table | is-empty) {
            print "No current table set. Setting the first table as current."
            let first_table = ($tables | first).name
            set_current_table $first_table
            $first_table
        } else {
            $current_table
        }
    }
}

# Lists all existing tables and shows the current table
export def ls_tables [] {
    let tables = (get_table_names)
    display_table_names $tables
    let current_table = (table_name)
    if not ($current_table | is-empty) {
        print $"Current table: ($current_table)"
    }
}

# Removes a specified table
export def rm_table [table_name: string] {
    if ((get_current_table_path) | path exists) {
        rm (get_current_table_path)
        print $"Removed table ($table_name)"
    } else {
        print $"Table ($table_name) does not exist"
    }
}

# Retrieves the name of the current table
export def get_current_table_name [] {
    if not ($current_table_path_store_file | path exists) {
        mkdir ($dynu_dir)
        let table_name = ensure_current_table
        {current_table: $table_name} | to nuon | save $current_table_path_store_file -f
        $table_name
    } else {
        let content = ($current_table_path_store_file | open)
        if ($content | is-empty) {
            ""
        } else {
            $content | get current_table
        }
    }
}

# Sets the current table name
export def set_current_table [table_name: string] {
    let tables = (get_table_names | get name)
    if $table_name in $tables {
        {current_table: $table_name} | to nuon | save $current_table_path_store_file -f
    } else {
        print $"Table ($table_name) does not exist. Cannot set as current table."
    }
}
