# dynu/utils.nu
# Utility commands for internal use and testing
export def apply_color [color: string, str: string] {
    $"(ansi $color)($str)(ansi reset)"
}