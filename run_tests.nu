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
# Run core tests in a new nushell process
nu tests/core_tests.nu
# Run user integration tests
print "Running user integration tests..."
# Invoke nushell to run the user integration tests (inherits HOME)
nu tests/user_tests.nu

print "All tests passed!"