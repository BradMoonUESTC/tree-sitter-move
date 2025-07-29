# Tree-sitter Move Parser

A Python library for parsing Aptos Move smart contract language, built on tree-sitter.

## ✨ Features

- **Pure Python Environment**: No need to install npm, cargo or other toolchains
- **Plug and Play**: Includes pre-compiled grammar files, ready to use out of the box
- **Complete Functionality**: Supports full Move language syntax parsing and analysis
- **Easy Integration**: Provides clean Python API interface
- **Comprehensive Testing**: Successfully parses all valid Move code samples

## 🚀 Quick Start

### Requirements

- Python 3.8+
- pip

### Installation

**Option 1: One-click Installation (Recommended)**
```bash
./setup.sh
```

**Option 2: Manual Installation**
```bash
# Create and activate virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install tree-sitter --trusted-host pypi.org --trusted-host files.pythonhosted.org

# Install this package
pip install -e .

# Run demo
python move_parser_demo.py
```

### Quick Test

```bash
# Run basic demo
python move_parser_demo.py

# Run comprehensive tests
python comprehensive_move_test.py
```

## 💻 Usage Example

### Basic Usage

```python
import tree_sitter_move as ts_move
from tree_sitter import Language, Parser

# Create parser
move_language = Language(ts_move.language())
parser = Parser()
parser.language = move_language

# Parse Move code
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

tree = parser.parse(bytes(move_code, "utf8"))

# Check parsing result
if tree.root_node.has_error:
    print("❌ Syntax error")
else:
    print("✅ Parsing successful")
    print(f"Root node type: {tree.root_node.type}")
    print(f"Number of child nodes: {tree.root_node.child_count}")
```

### Advanced AST Analysis

```python
def analyze_ast(node, depth=0):
    indent = "  " * depth
    print(f"{indent}├─ {node.type}")
    
    for child in node.children:
        if depth < 3:  # Limit depth
            analyze_ast(child, depth + 1)

# Analyze the AST structure
analyze_ast(tree.root_node)
```

## 📊 Test Results

The parser has been thoroughly tested with various Move code samples:

| File | Size | Lines | Description | Result |
|------|------|-------|-------------|---------|
| `basic_coin.move` | 1.9KB | 58 | Basic coin module with mint/transfer functions | ✅ Pass |
| `nft_collection.move` | 4.0KB | 150 | NFT collection with complex events and vectors | ✅ Pass |
| `defi_swap.move` | 6.9KB | 203 | DeFi swap module with generics and algorithms | ✅ Pass |
| `script_example.move` | 770B | 23 | Move script example | ✅ Pass |
| `syntax_error.move` | 579B | 29 | File with intentional syntax errors | ❌ Fail (Expected) |

**Overall Success Rate: 100% (4/4 valid files, 1 syntax error file correctly detected)**

## 🔧 Supported Move Syntax

### ✅ Successfully Parsed Features:
- Module definitions (`module 0x1::name`)
- Struct definitions with abilities (`has key, store`)
- Function definitions with visibility modifiers (`public fun`)
- Generic type parameters (`<T>`, `phantom`)
- References and borrowing (`&`, `&mut`)
- Complex expressions and control flow
- Script definitions (`script { }`)
- Comments and documentation
- Import statements (`use`)
- Error handling (`assert!`, `abort`)

### ✅ Advanced Features:
- Resource management (`move_to`, `borrow_global`)
- Event emission (`event::emit`)
- Vector operations
- String handling
- Conditional expressions and loops

### ✅ Error Detection:
- Accurately identifies syntax error locations
- Provides detailed error information
- Distinguishes between legal and illegal syntax structures

## 📁 Project Structure

```
tree-sitter-move/
├── src/                           # Pre-compiled grammar files
│   ├── grammar.json               # Grammar rules
│   ├── parser.c                   # Parser C code
│   └── scanner.c                  # External scanner
├── bindings/python/               # Python bindings
├── move_test_files/              # Test Move files
│   ├── basic_coin.move           # Basic coin module
│   ├── nft_collection.move       # NFT collection
│   ├── defi_swap.move            # DeFi swap module
│   └── script_example.move       # Script example
├── move_parser_demo.py           # Basic demo script
├── comprehensive_move_test.py    # Comprehensive test script
├── setup.py                      # Python package configuration
├── setup.sh                      # Installation script
└── README.md                     # This documentation
```

## 🌲 AST Analysis

The parser generates complete Abstract Syntax Trees (AST) including:
- Root node type identification
- Complete node hierarchy structure
- Detailed node type statistics
- Accurate position information

## 🎯 Use Cases

- Move code syntax analysis
- Smart contract code validation
- IDE syntax highlighting support
- Code formatting tools
- Documentation generation
- Code refactoring tools
- Static analysis tools
- Educational and learning tools

## 🔍 Troubleshooting

### SSL Certificate Error
```bash
pip install tree-sitter --trusted-host pypi.org --trusted-host files.pythonhosted.org --trusted-host pypi.python.org
```

### Import Error: No module named 'tree_sitter_move'
```bash
pip install -e .
```

### Virtual Environment Not Activated
```bash
source venv/bin/activate
```

## 🚀 Getting Started Tips

1. Use virtual environment to isolate dependencies
2. Perfect for Move code syntax analysis, highlighting, refactoring tool development
3. Suitable for integration into IDE plugins or code analysis tools
4. Tested with Python 3.13 on macOS, compatible with Python 3.8+

## 📄 License

Apache License 2.0 - See [LICENSE](LICENSE) file for details

---

🎉 **Enjoy using Tree-sitter Move Parser!**
