# dynu/constants.nu

# debug mode
export const is_debug_dynu = false
export const is_debug_fields = false
export const is_debug_tables = false
export def dynu_dir [] { $env.HOME + "/.dynu" }

# Define the path to the current table file
export def current_table_path_store_file [] { $env.HOME + "/.dynu/current_table.json" }
export const table_file_suffix = "_dynu.json"
