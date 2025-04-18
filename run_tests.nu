#!/usr/bin/env nu

# Automated test runner for dynu project (Nushell)

# Determine temporary home directory under tests
let cwd = $nu.pwd
let test_home = $cwd + "/tests/tmp_home"

# Clean up previous test home
rm --recursive --force $test_home

# Create fresh test home and set HOME env var
mkdir $test_home
$env.HOME = $test_home

echo "Using HOME = ($env.HOME) for dynu tests"

// Run core.nu tests
echo "Running core.nu tests..."
let core_test_script = $cwd + "/tests/core_tests.nu"
source $core_test_script

echo "All tests passed!"