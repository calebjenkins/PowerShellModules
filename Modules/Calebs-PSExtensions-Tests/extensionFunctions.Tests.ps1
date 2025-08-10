

Describe "Calebs-Version" {
    It "Returns the specific version for this module" {
        $result = Calebs-Version
        $result | Should -BeLike "Major"
    }
}

Describe "Test Test" {
    It "Should be 2" {
        $result = 1 + 1
        $result | Should -Be 2
    }
}
# Add more Describe blocks for other functions as needed
