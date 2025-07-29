module 0x1::syntax_error {
    use std::vector;
    
    // Error: missing struct name
    struct {
        value: u64,
    }
    
    // Error: misspelled function keyword
    publc fun test_function() {
        let x = 10;
        // Error: missing semicolon
        let y = 20
        
        // Error: undefined function
        unknown_function();
    }
    
    // Error: missing return type
    public fun get_value(): {
        42
    }
    
    // Error: syntax error in struct definition
    struct TestStruct has key
        field1: u64,
        field2: bool,
    }
} 