# Dynu CLI

Dynu CLI is a Nushell-based command-line utility for managing JSON-backed data tables and records. It provides simple commands to create and manipulate tables, fields, and records, persisting data under `~/.dynu`.

## Features
- Table management: create, list, set, and remove tables
- Field management: list, add, and remove fields in a table
- Record management: add, edit, remove, and purge records
- JSON persistence: tables stored as JSON files in `~/.dynu`
- Automated test suite for core and integration tests

## Requirements
- [Nushell](https://www.nushell.sh/) (>= 0.99)

## Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/luccahuguet/dynu.git
   cd dynu
   ```
2. Ensure Nushell (`nu`) is installed and in your `PATH`.
3. (Optional) Add an alias to your Nushell configuration (`~/.config/nushell/config.nu`):
   ```nu
   alias dynu = { source "/path/to/dynu/dynu.nu" }
   ```
4. You can now invoke commands via:
   - `nu dynu.nu <command>`
   - `dynu <command>` (if alias is configured)

## Usage

Run `main` to list available tables and show the current table:
```nu
nu dynu.nu main
```

### Command Abbreviations
Dynu CLI uses single-letter commands for brevity and simplicity. This design choice makes interactions concise but may require familiarity. Below is a quick reference for the abbreviations used in commands:

- **a**: Add (e.g., add a record or table)
- **e el**: Edit element (e.g., edit a record by index)
- **d el**: Delete element (e.g., remove a record by index)
- **d tb**: Delete table (e.g., remove a table)
- **l tbs**: List tables (e.g., show all tables)
- **l fds**: List fields (e.g., show fields in the current table)
- **a fd**: Add field (e.g., add a new field to the current table)
- **d fd**: Delete field (e.g., remove a field from the current table)
- **s tb**: Set table (e.g., switch to a different table)
- **p tb**: Purge table (e.g., clear all records from the current table)

Refer to the examples below for practical usage.

### Table Commands
- `l tbs` — List all tables
- `a tb <name> <field> <value>` — Create a new table with an initial record
- `s tb <name>` — Set the current table
- `d tb <name>` — Remove a table
- `p tb` — Remove all records from the current table

### Field Commands
- `l fds` — List fields in the current table
- `a fd <field>` — Add a new field to the current table
- `d fd <field>` — Remove a field from the current table

### Record Commands
- `a <field> <value>` — Add a record to the current table
- `e el <index> <field> <value>` — Edit a record by index
- `d el <index>` — Remove a record by index

### Examples
```nu
# Create and switch to a new table 'users'
nu dynu.nu a tb users name Alice
nu dynu.nu s tb users

# Add records
nu dynu.nu a age 30
nu dynu.nu a name Bob

# List fields and records
nu dynu.nu l fds
nu dynu.nu

# Edit and remove records
nu dynu.nu e el 1 age 31
nu dynu.nu d el 0
``` 

## Configuration
- Data directory: `~/.dynu` (override by setting the `HOME` environment variable)
- Current table stored in `~/.dynu/current_table.json`

## Testing
Run the automated test suite:
```sh
nu run_tests.nu
```
## Mascot
<div style="text-align: center;">
  <img src="assets/dynu-resized.jpg" alt="Dynu Mascot">
</div>

## Contributing
Contributions are welcome! Please open issues and pull requests on the [GitHub repository](https://github.com/luccahuguet/dynu).

## Documentation
See `llm_contex.md` for a detailed Nushell cheat sheet and code context for Dynu commands.
