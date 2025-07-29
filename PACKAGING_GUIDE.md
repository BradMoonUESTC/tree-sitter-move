# Tree-sitter Move Package Guide

## 📦 Package Installation

### Option 1: Install from Local Build (Current)

```bash
# Install from wheel (recommended)
pip install dist/tree_sitter_move-0.0.1-cp38-abi3-macosx_10_13_universal2.whl

# Or install from source distribution
pip install dist/tree_sitter_move-0.0.1.tar.gz
```

### Option 2: Install from Source Code

```bash
# Clone the repository
git clone <repository-url>
cd tree-sitter-move

# Install dependencies
pip install tree-sitter

# Install the package in development mode
pip install -e .
```

## 🚀 Quick Usage

```python
import tree_sitter_move as ts_move
from tree_sitter import Language, Parser

# Create parser
move_language = Language(ts_move.language())
parser = Parser(move_language)

# Parse Move code
move_code = """
module 0x1::example {
    public fun hello_world() {
        // Your Move code here
    }
}
"""

tree = parser.parse(bytes(move_code, "utf8"))

if tree.root_node.has_error:
    print("❌ Parse failed")
else:
    print("✅ Parse successful!")
    print(f"Root node: {tree.root_node.type}")
```

## 🔨 Building the Package

### Prerequisites

```bash
pip install build twine
```

### Build Process

```bash
# Clean previous builds
rm -rf build/ dist/

# Build package (both wheel and source distribution)
python -m build --no-isolation

# Check package quality
twine check dist/*
```

### Built Artifacts

After building, you'll have:
- `tree_sitter_move-0.0.1-cp38-abi3-macosx_10_13_universal2.whl` - Binary wheel package
- `tree_sitter_move-0.0.1.tar.gz` - Source distribution

## 📤 Publishing to PyPI (Optional)

### Test PyPI (Recommended for Testing)

```bash
# Upload to Test PyPI
twine upload --repository testpypi dist/*

# Install from Test PyPI
pip install --index-url https://test.pypi.org/simple/ tree-sitter-move
```

### Production PyPI

```bash
# Upload to PyPI
twine upload dist/*

# Install from PyPI
pip install tree-sitter-move
```

## 📋 Package Information

- **Name**: `tree-sitter-move`
- **Version**: `0.0.1`
- **Description**: Move grammar for tree-sitter
- **License**: Apache License 2.0
- **Python Support**: 3.8+
- **Dependencies**: `tree-sitter>=0.21.0`

## 🧪 Testing the Package

```python
# Test script
import tree_sitter_move as ts_move
from tree_sitter import Language, Parser

def test_parser():
    # Create parser
    move_language = Language(ts_move.language())
    parser = Parser(move_language)
    
    # Test cases
    test_cases = [
        "module 0x1::test { }",
        "script { fun main() {} }",
        "module 0x1::coin { struct Coin has key { value: u64 } }"
    ]
    
    for i, code in enumerate(test_cases, 1):
        tree = parser.parse(bytes(code, "utf8"))
        status = "✅" if not tree.root_node.has_error else "❌"
        print(f"Test {i}: {status} {code[:30]}...")
    
    print("🎉 All tests completed!")

if __name__ == "__main__":
    test_parser()
```

## 📂 Package Structure

```
tree-sitter-move/
├── dist/                          # Built packages
│   ├── tree_sitter_move-0.0.1-*.whl
│   └── tree_sitter_move-0.0.1.tar.gz
├── src/                           # Parser source code
├── bindings/python/               # Python bindings
├── pyproject.toml                 # Package configuration
├── setup.py                       # Build configuration
├── MANIFEST.in                    # Package manifest
└── README.md                      # Documentation
```

## 🔍 Troubleshooting

### SSL Certificate Issues
If you encounter SSL certificate errors during installation:
```bash
pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org --trusted-host pypi.python.org <package>
```

### Import Errors
Make sure the package is installed in the correct environment:
```bash
pip list | grep tree-sitter-move
```

### Parse Errors
Check if your Move code syntax is valid or if there are any missing dependencies.

---

🎉 **Your tree-sitter-move package is ready for distribution!** 