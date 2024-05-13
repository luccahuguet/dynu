# dynu/tables.nu
export use constants.nu [ current_table_path_store_file, is_debug_tables, dynu_dir]

export def get_current_table_path [] {
    let table_name = get_current_table_name
    print $"table_name: ($table_name)"
    print $"dynu_dir: ($dynu_dir)"
    $"($dynu_dir)/($table_name)_dynu.nuon"
}

export def table_name [] {get_current_table_name}

# Define a function to create a new table with a field and a value
export def add_table [new_table_name: string] { 
    print "\n\n init add table \n\n"
    if $is_debug_tables { print $"Debug: Adding table ($new_table_name) at path ($dynu_dir)/($new_table_name).nuon" }
    if not ($"($dynu_dir)/($new_table_name).nuon" | path exists) {
        print $"Creating table ($new_table_name)"
        let field_name = (input "Enter the name of the field: ")
        let field_value = (input "Enter the value for the field: ")
        let initial_data = ({$field_name: $field_value} | to nuon)
        $initial_data | save $"($dynu_dir)/($new_table_name)_dynu.nuon" -f
        print $"Created table ($new_table_name) with field ($field_name) and value ($field_value)"
        set_current_table $new_table_name
        print "\n\n end add table \n\n"
        $new_table_name
    } else {
        print $"Table ($new_table_name) already exists"
        $new_table_name
    }
}

# Define a function to get all table names
export def get_table_names [] {
    print "\n\n init get table names \n\n"
    if $is_debug_tables { print "Debug: Getting table names..." }
    let dynu_filenames = (glob $"($dynu_dir)/*.nuon" | where ($it | str ends-with "_dynu.nuon"))
    if ($dynu_filenames | is-empty) {
        print "No table files found"
        []
    } else {
        if $is_debug_tables { print $"Debug: Found ($dynu_filenames | length) table files" }
        if $is_debug_tables { print $"Debug: Table files: ($dynu_filenames)" }
        $dynu_filenames | each { |filename|
            let table_name: string = ($filename | parse "/home/lucca/.dynu/{name}_dynu.nuon" | get name | get 0)
            if $is_debug_tables { print $"Debug: Extracted table name: ($table_name)" }
            {name: $table_name}
        }
    }
}

# Define a function to display table names
export def display_table_names [tables: table] {
    if $is_debug_tables { print $"Debug: Displaying table names: ($tables)" }
    print $"Existing tables: "
    print ($tables | table)
}

# Define a function to ensure a current table exists, prompting the user to create one if necessary
export def ensure_current_table [] {
    if $is_debug_tables { print "Debug: Ensuring current table exists..." }
    let tables = (get_table_names)
    if ($tables | is-empty) {
        print "No tables found. Please create a new table."
        let new_table_name = (input "Enter the name of the new table: ")
        print "Creating new table..."
        add_table $new_table_name
        print "\n\n end ensure current table \n\n"
        $new_table_name

    } else {
        let current_table = (table_name)
        if $is_debug_tables { print $"Debug: Current table: ($current_table)" }

        if ($current_table | is-empty) {
            print "No current table set. Setting the first table as current."
            let first_table = ($tables | first).name
            set_current_table $first_table
            $first_table
        } else {
            # print $"\nCurrent table: ($current_table)"
            $current_table
        }
    }
}

# Define a function to list all tables
export def ls_tables [] {
    if $is_debug_tables { print "Debug: Listing tables..." }
    let tables = (get_table_names)
    display_table_names $tables
    let current_table = (table_name)
    if not ($current_table | is-empty) {
        print $"Current table: ($current_table)"
    }
}

# Define a function to remove a table
export def rm_table [table_name: string] {
    if $is_debug_tables { print $"Debug: Removing table ($table_name) at path (get_current_table_path)" }
    if ((get_current_table_path) | path exists) {
        rm (get_current_table_path)
        print $"Removed table ($table_name)"
    } else {
        print $"Table ($table_name) does not exist"
    }
}

# Define a function to get the current table name
export def get_current_table_name [] {
    if $is_debug_tables { print "Debug: Getting current table..." }
    if $is_debug_tables { print $"Debug: Current table path: ($current_table_path_store_file)" }
    if not ($current_table_path_store_file | path exists) {
        print "Current table file does not exist. Creating an empty one."
        print $"current_table: ($current_table_path_store_file)"
        mkdir ($dynu_dir)
        let table_name = ensure_current_table
        {current_table: $table_name} | to nuon | save $current_table_path_store_file -f
        print "\n\n end get current table \n\n"
        $table_name
    } else {
        if $is_debug_tables { print $"Debug: Reading current table from ($current_table_path_store_file)" }
        let content = ($current_table_path_store_file | open)
        if ($content | is-empty) {
            print "Current table file is empty"
            ""
        } else {
            if $is_debug_tables { print $"Debug: Parsed current table: ($content | get current_table)" }
            $content | get current_table
        }
    }
}


# Define a function to set the current table name
export def set_current_table [table_name: string] {
    print "\n\n init set current table \n\n"
    let tables = (get_table_names | get name)
    if $is_debug_tables { print $"Debug: Setting current table to ($table_name)" }
    if $table_name in $tables {
        print $"Setting current table to ($table_name)"
        {current_table: $table_name} | to nuon | save $current_table_path_store_file -f
        print "\n\n end set current table \n\n"
        } else {
        print $"Table ($table_name) does not exist. Cannot set as current table."
    }
}
