# dynu/core.nu

# Pure table manipulation functions

export def core_add [table: table, element: record] {
    $table | append $element
}

export def core_sort_by [table: table, field: string, reverse: bool] {
    if $field in ($table | columns) {
        let sorter = {|row| row | get $field}
        if $reverse {
            $table | sort-by $sorter --reverse
        } else {
            $table | sort-by $sorter
        }
    } else {
        $table
    }
}

export def core_remove_at [table: table, idx: number] {
    $table | drop nth $idx
}

export def core_update_at [table: table, idx: number, new: record] {
    $table | update $idx $new
}

export def core_purge [table: table] {
    []
}

export def core_add_field [table: table, field: string] {
    $table | each { |row| $row | insert $field null }
}

export def core_remove_field [table: table, field: string] {
    $table | each { |row| $row | reject $field }
}