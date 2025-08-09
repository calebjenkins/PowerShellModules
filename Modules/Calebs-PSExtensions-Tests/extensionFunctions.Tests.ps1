

Describe "Calebs-Version" {
    It "Returns the specific version for this module" {
        $result = Calebs-Version
        $result | Should -BeLike "Major"
    }
}

# Add more Describe blocks for other functions as needed
