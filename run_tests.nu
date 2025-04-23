#!/usr/bin/env nu

# Automated test runner for dynu project (Nushell)

# Determine temporary home directory under project root
let cwd = (pwd)
let test_home = $cwd + "/tests/tmp_home"

# Clean up previous test home
# Temporarily move HOME to cwd to allow rm without home-protection
let _old_home = $env.HOME
$env.HOME = $cwd
rm --recursive --force $test_home

# Create fresh test home and set HOME env var
mkdir $test_home
$env.HOME = $test_home

print $"Using HOME = ($env.HOME) for dynu tests"

## Run core.nu tests
print "Running core.nu tests..."
try {
    nu tests/core_tests.nu
    if $env.LAST_EXIT_CODE != 0 {
        print "Error: core.nu tests failed!"
        exit 1
    } else {
        print "core.nu tests passed."
    }
} catch {
    print "Error: core.nu tests encountered an exception."
    exit 1
}

# Run user integration tests
print "Running user integration tests..."
try {
    nu tests/user_tests.nu
    if $env.LAST_EXIT_CODE != 0 {
        print "Error: user integration tests failed!"
        exit 1
    } else {
        print "user integration tests passed."
    }
} catch {
    print "Error: user integration tests encountered an exception."
    exit 1
}

print "All tests passed!"
