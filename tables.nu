export use constants.nu [current_table_path_store_file, is_debug_tables, dynu_dir, table_file_suffix]

# Returns the path of the current table file
export def get_current_table_path [] {
    let table_name = get_current_table_name
    (dynu_dir) + "/" + $table_name + $table_file_suffix
}

# Alias for get_current_table_name
export def table_name [] { get_current_table_name }

# Creates a new table with an initial field and value (a is for add table)
def add_table [new_table_name: string, init_field: string, init_value: string] {
    let file_path = (dynu_dir) + "/" + $new_table_name + $table_file_suffix
    if not ($file_path | path exists) {
        let initial_row = { ($init_field): $init_value }
        mkdir (dynu_dir)
        [ $initial_row ] | to json --raw | save $file_path -f
        set_current_table $new_table_name
    }
    $new_table_name
}

# User-facing add table command (a is for add)
export def "a tb" [name: string, field: string, value: string] {
    if ($name | is-empty) or ($field | is-empty) or ($value | is-empty) {
        error make {msg: "Error: Name, field, and value must not be empty"}
    }
    add_table $name $field $value
}

# Retrieves all table names from the dynu directory
def get_table_names [] {
    let dir = (dynu_dir)
    if not ($dir | path exists) {
        []
    } else {
        let nuon_files = (glob $"($dir)/*_dynu.nuon")
        if not ($nuon_files | is-empty) {
            $nuon_files | each { |f|
                let data = (open $f)
                let new_file = ($f | str replace ".nuon" ".json")
                $data | collect | to json --raw | save $new_file -f
                rm $f
            }
        }
        let pattern = $"(dynu_dir)/*($table_file_suffix)"
        let files = (glob $pattern)
        let names = ($files | each { |f| ($f | path basename | str replace $table_file_suffix "") })
        $names
    }
}

# User-facing command to list tables (l is for list)
export def "l tbs" [] {
    let names = (get_table_names | sort)
    if ($names | is-empty) {
        "Existing tables:"
    } else {
        "Existing tables: " + ($names | str join " ")
    }
}

# Ensures a current table exists
def ensure_current_table [] {
    let tables = (get_table_names)
    if ($tables | is-empty) {
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

def rm_table [table_name: string] {
    let file_path = (dynu_dir) + "/" + $table_name + $table_file_suffix
    if not ($file_path | path exists) {
        error make {msg: $"Error: Table ($table_name) not found"}
    }
    rm $file_path
    print $"Removed table ($table_name)"
}

# User-facing remove table command (d is for delete)
export def "d tb" [name: string] {
    if ($name | is-empty) {
        error make {msg: "Error: Table name must not be empty"}
    }
    rm_table $name
}

# Retrieves the name of the current table
export def get_current_table_name [] {
    let json_path = current_table_path_store_file
    let old_path = ($json_path | str replace ".json" ".nuon")
    if (not ($json_path | path exists)) and ($old_path | path exists) {
        let content = (open $old_path)
        $content | collect | to json --raw | save $json_path -f
        rm $old_path
    }
    if not ($json_path | path exists) {
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

# User-facing set table command (s is for set)
export def "s tb" [name: string] {
    if ($name | is-empty) {
        error make {msg: "Error: Table name must not be empty"}
    }
    if ($name not-in (get_table_names)) {
        error make {msg: $"Error: Table ($name) does not exist"}
    }
    set_current_table $name
}
