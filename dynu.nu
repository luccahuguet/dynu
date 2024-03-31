# dynu/dynu.nu
export use constants.nu *
export use field_names.nu *

def interactive_construct_element [] {
  let field_names = (load_field_names)
  open $field_names_path
  let element = ($field_names | each { |field|
    print "Enter value for $($field): "
    let value = (input)
    if ($value | is-empty) { null } else { {($field): $value} }
  })
  $element
}

# Define a function to add a new item to the dynu table
export def add [] {
    let element = (interactive_construct_element)
    let final_table = (ls_elms | append $element)
    echo $" the final table is ($final_table)"
    $final_table | to nuon | save $dynu_path -f
}


# Define a function to list the current dynu table items
export def ls [] {
    ls_elms
}

# Define a function to read the dynu table from the file
export def ls_elms [] {
    if not ($dynu_path | path exists) {
        "[]" | save $dynu_path -f
    } else {
        open $dynu_path
    }
}

# Define a function to remove an item from the dynu table by index
def table_rm [elm_idx: number] {
    ls_elms | drop nth $elm_idx | save $dynu_path -f
}

# Define a function to purge the dynu table
export def purge [] {
    "[]" | save $dynu_path -f
    "[]" | save $field_names_path -f
}