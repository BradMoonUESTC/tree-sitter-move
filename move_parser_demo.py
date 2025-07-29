#!/usr/bin/env python3
"""
Move Language Parser Demo
"""

def main():
    print("🚀 Move Language Parser Demo")
    print("=" * 50)
    
    try:
        import tree_sitter_move as ts_move
        from tree_sitter import Language, Parser
        
        # Create parser
        move_language = Language(ts_move.language())
        parser = Parser()
        parser.language = move_language
        
        print("✅ Move parser created successfully!")
        print(f"📦 Language: {move_language.name or 'move_on_aptos'}")
        
        # Example Move code
        move_code = """
module 0x1::coin {
    struct Coin has key, store {
        value: u64,
    }
    
    public fun mint(value: u64): Coin {
        Coin { value }
    }
    
    public fun get_value(coin: &Coin): u64 {
        coin.value
    }
}
"""
        
        print("\n📝 Parsing Move code:")
        print(move_code.strip())
        print("-" * 30)
        
        # Parse code
        print("\n⚡ Starting parse...")
        tree = parser.parse(bytes(move_code, "utf8"))
        
        if tree.root_node.has_error:
            print("❌ Parse failed, syntax error detected!")
        else:
            print("✅ Parse successful!")
            print(f"🌳 Root node type: {tree.root_node.type}")
            print(f"📊 Child node count: {tree.root_node.child_count}")
            
            print("\n🎉 Move code parsing completed!")
            
    except ImportError as e:
        print(f"❌ Import error: {e}")
        print("Please make sure tree-sitter-move package is installed")
    except Exception as e:
        print(f"❌ Other error: {e}")

if __name__ == "__main__":
    main() 