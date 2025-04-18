# dynu/dynu.nu
export use constants.nu [is_debug_dynu]
export use fields.nu ["ls fields", "add field", "rm field"]
export use tables.nu [get_current_table_name, add_table, ls_tables, rm_table, set_current_table]
export use tables.nu [ensure_current_table, get_table_names, table_name, get_current_table_path]
export use core.nu [core_add, core_sort_by, core_remove_at, core_update_at, core_purge]

# To do: Add table titles
# To do: Add table descriptions
# To do: print current table name on table ls
# To do: create a dir to save every file used by dynu
export def apply_color [color: string, str: string] { $"(ansi $color)($str)(ansi reset)" }

def interactive_construct_element [] {
    let field_names = (ls fields)
    if $is_debug_dynu { print $"Debug: Table name: (table_name), Field names: ($field_names)" }
    let element = ($field_names | each { |field|
        let value = (input $"($field): ")
        if ($value | is-empty) { {($field): null} } else { {($field): $value} }
    })
    $element | reduce { |it, acc| $acc | merge $it } | default {}
}

# Define a function to add a new item to the current dynu table
export def add [] {
    if $is_debug_dynu { print $"Debug: Adding element to table (table_name) at path (get_current_table_path)" }
    let element = interactive_construct_element
    let table = ls_elms
    let updated_table = core_add table element
    if $is_debug_dynu { print $"Debug: Final table: ($updated_table)" }
    print $"Element added to table (table_name)"
    save_sort_show updated_table "grade"
}

# Define a function to read the current dynu table from the file
export def ls_elms [--show] {
    if $is_debug_dynu { print "Debug: Listing current dynu table items" }
    if $is_debug_dynu { print $"Debug: Reading table (table_name) from path (get_current_table_path)" }
    let table_data = (get_current_table_path) | open
    if $show {
        color_by_grade $table_data
    } else {
        $table_data
    }
}

def color_by_grade [table] {
    let field_names = ($table | columns)
    let colored_table = if "grade" in $field_names {
        $table | each { |row|
            let grade = ($row | get "grade")
            let grade_number = $grade | into int
            match $grade_number {
                1..2 => { $row | update "grade" (apply_color "red" $grade)},
                3..4 => { $row | update "grade" (apply_color "xterm_darkorange" $grade)},
                5..6 => { $row | update "grade" (apply_color "yellow" $grade)},
                7..8 => { $row | update "grade" (apply_color "blue" $grade)},
                9..10 => { $row | update "grade" (apply_color "green" $grade)},
                _ => $row            
            }
        }
    } else {
        $table
    }
    $colored_table
}

# Define a function to edit an item in the current dynu table by index
export def "edit elm" [elm_idx: number] {
    if $is_debug_dynu { print $"Debug: Editing element at index ($elm_idx) in table (table_name) at path (get_current_table_path)" }
    let table = ls_elms
    # let element = ($table | enumerate | get $elm_idx)
    let element = ($table | get $elm_idx)
    let field_names = ($element | columns)
    let updated_element = ($field_names | each { |field|
        let current_value = ($element | get $field)
        let new_value = (input $"($field) [($current_value)]: ")
        if ($new_value | is-empty) { {($field): $current_value} } else { {($field): $new_value} }
    } | reduce { |it, acc| $acc | merge $it } | default {})
    let updated_table = core_update_at table elm_idx updated_element
    save_sort_show updated_table "grade"
}

export def save_sort_show [table: table, field: string] {
    if $is_debug_dynu { print $"Debug: Sorting table by field ($field)" }
    let sorted = core_sort_by table field true
    if $is_debug_dynu { print $"Debug: Sorted table: ($sorted)" }
    sorted | to nuon | save (get_current_table_path) -f
    ls_elms --show
}

# Define a function to remove an item from the current dynu table by index
export def "rm elm" [elm_idx: number] {
    if $is_debug_dynu { print $"Debug: Removing element at index ($elm_idx) from table (table_name) at path (get_current_table_path)" }
    let table = ls_elms
    let updated_table = core_remove_at table elm_idx
    save_sort_show updated_table "grade"
}

# Define a function to purge the current dynu table
export def purge [] {
    if $is_debug_dynu { print $"Debug: Purging table (table_name) at path (get_current_table_path)" }
    let table = ls_elms
    let updated_table = core_purge table
    updated_table | to nuon | save (get_current_table_path) -f
}

export def main [] {
    print "\nWelcome to the dynu CLI!"
    print "You can now manage dynamic persistent tables with ease."
    print "Type `dynu` and hit tab to see the available commands."
}

