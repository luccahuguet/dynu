

export const nulist_path = "~/.nulist.nuon"

export def sv_show [] { save $nulist_path -f | open $nulist_path}
export def ls [] { ls_elms }

def list_rm [
    elm_idx: number # The index of the element to be removed from the list
] {
    ls_elms | drop nth $elm_idx | sv_show
}

# Add elements
export def add [
    elm_name: string # The element to be added to the list
] {
    ls_elms | append $elm_name | sv_show
}

# Lists all elements
export def ls_elms [] {
    if not ($nulist_path| path exists) {
        "[]" | sv_show
    }
}

