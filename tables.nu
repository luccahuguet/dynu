export use constants.nu [current_table_path_store_file, is_debug_tables, dynu_dir, table_file_suffix]

# Returns the path of the current table file
export def get_current_table_path [] {
    let table_name = get_current_table_name
    $"(dynu_dir)/($table_name)($table_file_suffix)"
}

# Alias for get_current_table_name
export def table_name [] { get_current_table_name }

# Creates a new table with an initial field and value
def add_table [new_table_name: string] {
        let file_path = $"(dynu_dir)/($new_table_name)($table_file_suffix)"
    if not ($file_path | path exists) {
        let field_name = (input "Enter the name of the field: ")
        let field_value = (input "Enter the value for the field: ")
        let initial_data = ({$field_name: $field_value} | to nuon)
        # Ensure dynu directory exists
        mkdir (dynu_dir)
        echo $initial_data | save $file_path -f
        set_current_table $new_table_name
    }
    $new_table_name
}
#+ User-facing add table command
export def "add table" [name: string] { add_table name }

# Retrieves all table names from the dynu directory
def get_table_names [] {
let pattern = $"(dynu_dir)/*($table_file_suffix)"
    let dynu_filenames = (glob $pattern)
    if ($dynu_filenames | is-empty) {
        []
    } else {
        $dynu_filenames | each { |filename|
            let table_name: string = (
                $filename
| parse $"(dynu_dir)/{{name}}($table_file_suffix)"
                | get name
                | get 0
            )
            {name: $table_name}
        }
    }
}

# User-facing command to list tables (alias: "ls tables")
export def "ls tables" [] {
    let names = (get_table_names | get name)
    if ($names | is-empty) {
        "Existing tables:"
    } else {
        (["Existing tables:"] | append $names) | str join " "
    }
}

# Ensures a current table exists, creating one if necessary
def ensure_current_table [] {
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

#+ Alias ls_tables = "ls tables" defined below for testing
# User-facing add table already provided above

def rm_table [table_name: string] {
    let file_path = $"(dynu_dir)/($table_name)($table_file_suffix)"
    if ($file_path | path exists) {
        rm $file_path
        print $"Removed table ($table_name)"
    } else {
        print $"Table ($table_name) does not exist"
    }
}
#+ User-facing rm table command
export def "rm table" [name: string] { rm_table name }

# Retrieves the name of the current table
export def get_current_table_name [] {
    if not ((current_table_path_store_file) | path exists) {
        mkdir (dynu_dir)
        let table_name = ensure_current_table
        {current_table: $table_name} | to nuon | save (current_table_path_store_file) -f
        $table_name
    } else {
        let content = (current_table_path_store_file | open)
        if ($content | is-empty) {
            ""
        } else {
            $content | get current_table
        }
    }
}

def set_current_table [table_name: string] {
    {current_table: $table_name} | to nuon | save (current_table_path_store_file) -f
}
#+ User-facing set current table command
export def "set current table" [name: string] { set_current_table name }

# Aliases for testing (snake_case)
alias ls_tables = ls tables
alias add_table = add table
alias rm_table = rm table
