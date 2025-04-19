export use constants.nu [current_table_path_store_file, is_debug_tables, dynu_dir, table_file_suffix]

# Returns the path of the current table file
export def get_current_table_path [] {
    let table_name = get_current_table_name
    # Build path to the current table file
    (dynu_dir) + "/" + $table_name + $table_file_suffix
}

# Alias for get_current_table_name
export def table_name [] { get_current_table_name }

# Creates a new table with an initial field and value
def add_table [new_table_name: string, init_field: string, init_value: string] {
    # Build path for the new table file
    let file_path = (dynu_dir) + "/" + $new_table_name + $table_file_suffix
    if not ($file_path | path exists) {
        # Create initial table with a single record using provided field and value
        let initial_row = { ($init_field): $init_value }
        mkdir (dynu_dir)
        [ $initial_row ] | to json --raw | save $file_path -f
        set_current_table $new_table_name
    }
    $new_table_name
}
# User-facing add table command without interactive input
export def "add table" [name: string, field: string, value: string] { add_table $name $field $value }

# Retrieves all table names from the dynu directory
def get_table_names [] {
    # Return list of table names (without suffix) from dynu directory
    let dir = (dynu_dir)
    if not ($dir | path exists) {
        []
    } else {
        # Migrate old nuon table files to JSON format
        let nuon_files = (glob $"($dir)/*_dynu.nuon")
        if not ($nuon_files | is-empty) {
            $nuon_files | each { |f|
                let data = (open $f)
                let new_file = ($f | str replace ".nuon" ".json")
                $data | collect | to json --raw | save $new_file -f
                rm $f
            }
        }
        # Use glob to match table files with JSON suffix and extract names
        let pattern = $"(dynu_dir)/*($table_file_suffix)"
        let files = (glob $pattern)
        let names = ($files | each { |f|
            # Extract basename and remove suffix
            let base = ($f | path basename)
            ($base | str replace $table_file_suffix "")
        })
        $names
    }
}

# User-facing command to list tables (alias: "ls tables")
export def "ls tables" [] {
    # List tables by retrieving existing table names
    let names = (get_table_names)
    if ($names | is-empty) {
        # No tables
        "Existing tables:"
    } else {
        # Join table names into a space-separated string
        let names_str = ($names | sort | str join " ")
        # Prefix header with joined names
        "Existing tables: " + $names_str
    }
}

# Ensures a current table exists, returning an existing or first table without interactive input
def ensure_current_table [] {
    let tables = (get_table_names)
    if ($tables | is-empty) {
        # No tables exist; return empty
        ""
    } else {
        let current = (table_name)
        if ($current | is-empty) {
            let first = ($tables | first)
            set_current_table $first
            $first
        } else {
            $current
        }
    }
}

#+ Alias ls_tables = "ls tables" defined below for testing
# User-facing add table already provided above

def rm_table [table_name: string] {
    # Build path to the table file to remove
    let file_path = (dynu_dir) + "/" + $table_name + $table_file_suffix
    if ($file_path | path exists) {
        rm $file_path
        print $"Removed table ($table_name)"
    } else {
        print $"Table ($table_name) does not exist"
    }
}
#+ User-facing rm table command
export def "rm table" [name: string] { rm_table $name }

# Retrieves the name of the current table
export def get_current_table_name [] {
    let json_path = current_table_path_store_file
    let old_path = ($json_path | str replace ".json" ".nuon")
    # Migrate old current_table file if present
    # If old Nuon current_table file exists, migrate it
    if (not ($json_path | path exists)) and ($old_path | path exists) {
        let content = (open $old_path)
        $content | collect | to json --raw | save $json_path -f
        rm $old_path
    }
    if not (($json_path) | path exists) {
        mkdir (dynu_dir)
        let table_name = ensure_current_table
        {current_table: $table_name} | to json --raw | save $json_path -f
        $table_name
    } else {
        let content = ($json_path | open)
        if ($content | is-empty) {
            ""
        } else {
            $content | get current_table
        }
    }
}

def set_current_table [table_name: string] {
    {current_table: $table_name} | to json --raw | save (current_table_path_store_file) -f
}
#+ User-facing set current table command
export def "set current table" [name: string] { set_current_table $name }

# Aliases for testing (snake_case)
alias ls_tables = ls tables
alias add_table = add table
alias rm_table = rm table
