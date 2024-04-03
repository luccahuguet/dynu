# dynu/dynu.nu
export use constants.nu [get_dynu_path, is_debug_dynu]
export use fields.nu ["ls fields", "add field", "rm field"]
export use tables.nu [get_current_table, "add table", "ls tables", "rm table", set_current_table, ensure_current_table, get_table_names]

# To do: Add table titles
# To do: Add table descriptions
# To do: print current table name on table ls

def interactive_construct_element [] {
    let table_name = (get_current_table)
    let field_names = (ls fields)
    if $is_debug_dynu { print $"Debug: Table name: ($table_name), Field names: ($field_names)" }
    let element = ($field_names | each { |field|
        let value = (input $"($field): ")
        if ($value | is-empty) { {($field): null} } else { {($field): $value} }
    })
    $element | reduce { |it, acc| $acc | merge $it } | default {}
}

# Define a function to add a new item to the current dynu table
export def add [] {
    let table_name = (ensure_current_table)
    let dynu_path = (get_dynu_path $table_name)
    if $is_debug_dynu { print $"Debug: Adding element to table ($table_name) at path ($dynu_path)" }
    let element = (interactive_construct_element)
    let final_table = (ls_elms | append $element)
    if $is_debug_dynu { print $"Debug: Final table: ($final_table)" }
    echo $" the final table is ($final_table)"
    $final_table | to nuon | save $dynu_path -f
}

# Define a function to read the current dynu table from the file
def ls_elms [] {
    if $is_debug_dynu { print "Debug: Listing current dynu table items" }
    let table_name = (ensure_current_table)
    let dynu_path = (get_dynu_path $table_name)
    if $is_debug_dynu { print $"Debug: Reading table ($table_name) from path ($dynu_path)" }
    open $dynu_path
}

# Define a function to edit an item in the current dynu table by index
export def "edit elm" [elm_idx: number] {
    let table_name = (ensure_current_table)
    let dynu_path = (get_dynu_path $table_name)
    if $is_debug_dynu { print $"Debug: Editing element at index ($elm_idx) in table ($table_name) at path ($dynu_path)" }
    let table = (ls_elms)
    let element = ($table | get $elm_idx)
    let field_names = ($element | columns)
    let updated_element = ($field_names | each { |field|
        let current_value = ($element | get $field)
        let new_value = (input $"($field) [($current_value)]: ")
        if ($new_value | is-empty) { {($field): $current_value} } else { {($field): $new_value} }
    } | reduce { |it, acc| $acc | merge $it } | default {})
    let updated_table = ($table | update $elm_idx $updated_element)
    $updated_table | to nuon | save $dynu_path -f
}

# Define a function to remove an item from the current dynu table by index
export def "rm elm" [elm_idx: number] {
    let table_name = (ensure_current_table)
    let dynu_path = (get_dynu_path $table_name)
    if $is_debug_dynu { print $"Debug: Removing element at index ($elm_idx) from table ($table_name) at path ($dynu_path)" }
    ls_elms | drop nth $elm_idx | to nuon | save $dynu_path -f
}

# Define a function to purge the current dynu table
export def purge [] {
    let table_name = (ensure_current_table)
    let dynu_path = (get_dynu_path $table_name)
    if $is_debug_dynu { print $"Debug: Purging table ($table_name) at path ($dynu_path)" }
    [] | to nuon | save $dynu_path -f
}

export def main [] {
    print "\nWelcome to the dynu CLI!"
    print "You can now manage dynamic persistent tables with ease."
    print "Type `dynu` and hit tab to see the available commands."
}

export alias ls = ls_elms