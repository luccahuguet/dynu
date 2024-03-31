# dynu/dynu.nu
export use constants.nu [get_dynu_path]
export use fields.nu [get_field_names]
export use tables.nu [get_current_table, "add table", "ls tables", "rm table", set_current_table, ensure_current_table]

def interactive_construct_element [] {
    let table_name = (get_current_table)
    let field_names = (get_field_names)
    let element = ($field_names | each { |field|
        let value = (input $"($field): ")
        if ($value | is-empty) {
            {($field): null}
        } else {
            {($field): $value}
        }
    })
    $element | reduce { |it, acc| $acc | merge $it } | default {}
}

# Define a function to add a new item to the current dynu table
export def add [] {
    let table_name = (ensure_current_table)
    let dynu_path = (get_dynu_path $table_name)
    let element = (interactive_construct_element)
    let final_table = (ls_elms | append $element)
    echo $" the final table is ($final_table)"
    $final_table | to nuon | save $dynu_path -f
}

# Define a function to list the current dynu table items
export def ls [] {
    ls_elms
}

# Define a function to read the current dynu table from the file
export def ls_elms [] {
    let table_name = (ensure_current_table)
    let dynu_path = (get_dynu_path $table_name)
    open $dynu_path
}

# Define a function to remove an item from the current dynu table by index
def table_rm [elm_idx: number] {
    let table_name = (ensure_current_table)
    let dynu_path = (get_dynu_path $table_name)
    ls_elms | drop nth $elm_idx | to nuon | save $dynu_path -f
}

# Define a function to purge the current dynu table
export def purge [] {
    let table_name = (ensure_current_table)
    let dynu_path = (get_dynu_path $table_name)
    [] | to nuon | save $dynu_path -f
}