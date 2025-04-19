# Nushell Cheat Sheet for Dynu CLI (LLM Context)

This document captures key Nushell syntax patterns and commands used in the Dynu CLI (`dynu.nu`) and its test suite. It can help an LLM understand how Dynu scripts work and how to extend or debug them.

## 1. Variables and Command Substitution
- Assign output of a command to a variable:
  ```nu
  let var = (pwd)
  let files = (ls /path/to/dir)
  ```
- Access environment variables:
  ```nu
  print $env.HOME
  $env.HOME = "/tmp/test_home"
  ```

## 2. Working with JSON
- Open and parse JSON from a file:
  ```nu
  let data = open --raw path/to/file.json | from json
  ```
- Serialize and save structured data back to JSON:
  ```nu
  $table | to json --raw | save path/to/file.json -f
  ```

## 3. Table and Record Manipulation
- Basic table operations use Nushell built-ins and dynu core functions:
  - Append an element (record) to a table:
    ```nu
    let updated = (core_add $table {name: "alice", score: 10})
    ```
  - Remove element by index:
    ```nu
    let pruned = (core_remove_at $table 2)
    ```
  - Update an entire record at index:
    ```nu
    let updated = (core_update_at $table 1 {name: "bob", score: 20})
    ```
  - Purge (clear) a table:
    ```nu
    let empty = (core_purge $table)
    ```

## 4. Indexing and Merging Records
- Extract an element at a given index:
  ```nu
  let element = ($table | get 0)
  ```
- Update a single field in a record without touching others:
  ```nu
  let new_record = ($element | merge {"score": 42})
  ```

## 5. Sorting and Selecting Columns
- Sort a table by a record field:
  ```nu
  let sorted = (core_sort_by $table "name" true)
  ```
- List available columns (fields) in a table:
  ```nu
  let cols = ($table | columns | sort)
  ```

## 6. Nushell Pipelines and Loops
- Enumerate rows and transform:
  ```nu
  $table
  | enumerate
  | each { |row|
      if $row.index == 1 { #{ updated row } } else { $row.item }
    }
  ```
- Apply a command to each file or item:
  ```nu
  glob "/tmp/*.json" | each { |f| open --raw $f | from json }
  ```

## 7. Defining Commands and Aliases
- Define a custom command:
  ```nu
  export def "e elm" [idx: number, field: string, value: string] {
    # body...
  }
  ```
- Create a snake_case alias for testing:
  ```nu
  alias edit_elm = edit elm
  ```

## 8. File and Path Operations
- Check for file existence:
  ```nu
  if (path exists $path) { ... }
  ```
- Use `glob` to list files matching patterns:
  ```nu
  let tables = (glob "$env.HOME/.dynu/*_dynu.json")
  ```

## 9. Testing Patterns with `std/assert`
- Assert that a string contains a substring:
  ```nu
  assert str contains $output "Expected"
  ```
- Assert equality of values:
  ```nu
  assert equal ($data | length) 3
  ```

## 10. Common Debugging Aids
- Print debug messages conditionally:
  ```nu
  if $is_debug_dynu { print "Debug: current table = ($table_name)" }
  ```
- Dump raw and parsed JSON for inspection:
  ```nu
  print (open --raw $file_path)
  print (open $file_path)
  ```

---
This cheat sheet outlines the fundamental Nushell idioms and dynu-specific patterns to help an LLM or new contributor read, debug, and extend the Dynu codebase.
