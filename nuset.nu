

export const nusets_path = "~/.nusets.nuon"

export def sv [] { save $nusets_path -f}
export def ls [] { ls_sets }

def set_rm [
    set: list # The set 
    elm_removed: string # The name of the element to be removed
] {
  $set | filter {|e| $e != $elm_removed}
}

# Lists all sets
export def ls_sets [] {
    if not ($nusets_path| path exists) {
        "[]" | save $nusets_path
    }
    open $nusets_path
}

# A function that adds a new set
export def add [
	elm: string # The name of the set to be added
] {
	ls_sets | append $elm | sv
}

# Remove elements
export def rm [
    elm: string # The name of the set to be removed
] {
  # ls_sets | describe
  set_rm (ls_sets) $elm | sv
}
