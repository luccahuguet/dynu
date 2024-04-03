# dynu/tables.nu
export use constants.nu [ get_dynu_path, current_table_path, is_debug_tables ]

# Define a function to create a new table with a field and a value
export def "add table" [table_name: string] {
    let dynu_path = (get_dynu_path $table_name)
    if $is_debug_tables { print $"Debug: Adding table ($table_name) at path ($dynu_path)" }
    if not ($dynu_path | path exists) {
        print $"Creating table ($table_name)"
        let field_name = (input "Enter the name of the field: ")
        let field_value = (input "Enter the value for the field: ")
        let initial_data = ({$field_name: $field_value} | to nuon)
        $initial_data | save $dynu_path -f
        print $"Created table ($table_name) with field ($field_name) and value ($field_value)"
        set_current_table $table_name
        $table_name
    } else {
        print $"Table ($table_name) already exists"
        $table_name
    }
}

# Define a function to get all table names
export def get_table_names [] {
    if $is_debug_tables { print "Debug: Getting table names..." }
    let dynu_filenames = (glob "~/*.nuon" | where ($it | str ends-with "_dynu.nuon"))
    if ($dynu_filenames | is-empty) {
        print "No table files found"
        []
    } else {
        if $is_debug_tables { print $"Debug: Found ($dynu_filenames | length) table files" }
        if $is_debug_tables { print $"Debug: Table files: ($dynu_filenames)" }
        $dynu_filenames | each { |filename|
            let table_name: string = ($filename | parse "{_}.{name}_dynu.nuon" | get name | get 0)
            if $is_debug_tables { print $"Debug: Extracted table name: ($table_name)" }
            {name: $table_name}
        }
    }
}

# Define a function to display table names
export def display_table_names [tables: table] {
    if $is_debug_tables { print $"Debug: Displaying table names: ($tables)" }
    print $"Existing tables: "
    echo ($tables | table)
}

# Define a function to ensure a current table exists, prompting the user to create one if necessary
export def ensure_current_table [] {
    if $is_debug_tables { print "Debug: Ensuring current table exists..." }
    let current_table = (get_current_table)
    if $is_debug_tables { print $"Debug: Current table: ($current_table)" }
    let tables = (get_table_names)
    if ($tables | is-empty) {
        print "No tables found. Please create a new table."
        let new_table_name = (input "Enter the name of the new table: ")
        add table $new_table_name
    } else {
        if ($current_table | is-empty) {
            print "No current table set. Setting the first table as current."
            let first_table = ($tables | first).name
            set_current_table $first_table
            $first_table
        } else {
            print $"\nCurrent table: ($current_table)"
            $current_table
        }
    }
}

# Define a function to list all tables
export def "ls tables" [] {
    if $is_debug_tables { print "Debug: Listing tables..." }
    let tables = (get_table_names)
    display_table_names $tables
    let current_table = (get_current_table)
    if not ($current_table | is-empty) {
        print $"Current table: ($current_table)"
    }
}

# Define a function to remove a table
export def "rm table" [table_name: string] {
    let dynu_path = (get_dynu_path $table_name)
    if $is_debug_tables { print $"Debug: Removing table ($table_name) at path ($dynu_path)" }
    if ($dynu_path | path exists) {
        rm $dynu_path
        print $"Removed table ($table_name)"
    } else {
        print $"Table ($table_name) does not exist"
    }
}

# Define a function to get the current table name
export def get_current_table [] {
    if $is_debug_tables { print "Debug: Getting current table..." }
    if not ($current_table_path | path exists) {
        print "Current table file does not exist. Creating an empty one."
        {current_table: ""} | to nuon | save $current_table_path -f
        ""
    } else {
        if $is_debug_tables { print $"Debug: Reading current table from ($current_table_path)" }
        let content = (open $current_table_path)
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
    let tables = (get_table_names | get name)
    if $is_debug_tables { print $"Debug: Setting current table to ($table_name)" }
    if $table_name in $tables {
        print $"Setting current table to ($table_name)"
        {current_table: $table_name} | to nuon | save $current_table_path -f
    } else {
        print $"Table ($table_name) does not exist. Cannot set as current table."
    }
}