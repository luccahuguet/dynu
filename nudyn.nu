
const debug = false

export const nulist_path = "~/.nulist.nuon"

export def sv_show [] { save $nulist_path -f } 

export def ls [] { ls_elms }

const attr_types = {
    'name': 'string',
    'price': 'float'
    'desc': 'string'
}

const list_name = "wishlist"
const elm_name = "item"

def prompt_and_convert [
    attr: string,
    expected_type: string
] {
    echo $"Adding an ($elm_name) to the ($list_name)...\n"
    let value = input $"($attr) \(type ($expected_type)): "
    match $expected_type {
        'string' => { $value }
        'float' => { $value | into float | default 0) }
        _ => { echo "Unsupported type for attribute: $attr"; null }
    }
}

def interactive_construct_element [] {
    let attrs = $attr_types | items { |attr, expected_type|
        let converted_value = (prompt_and_convert $attr $expected_type)
        if ($converted_value | is-empty) { 
            null 
        } else { 
            {$attr: $converted_value} 
        }
    }

    let element = ($attrs | reduce { |acc, val| $acc | merge $val })
    $element
}

export def add [] {
    let element = (interactive_construct_element)
    let final_list = ls_elms | append $element
    echo $" the final list is ($final_list)"
    $final_list | to nuon | sv_show
}

export def ls_elms [] {
    if not ($nulist_path | path exists) {
        "[]" | sv_show
    } else {
        open $nulist_path
    }
}

def list_rm [
    elm_idx: number
] {
    ls_elms | drop nth $elm_idx | sv_show
}
