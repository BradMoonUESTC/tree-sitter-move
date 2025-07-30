# Tree-sitter Move Parser

A Python library for parsing Aptos Move smart contract language, built on tree-sitter.

source:
https://github.com/BradMoonUESTC/tree-sitter-move

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

## 🎉 打包完成！您的tree-sitter-move包已经成功构建

### ✅ 完成的工作

1. **包配置完善**
   - 更新了 `pyproject.toml` 配置文件
   - 添加了作者信息、依赖关系、项目URL
   - 创建了 `MANIFEST.in` 文件管理包文件

2. **成功构建了两种分发包**
   - **Wheel包** (154KB): `tree_sitter_move-0.0.1-cp38-abi3-macosx_10_13_universal2.whl`
   - **源码包** (344KB): `tree_sitter_move-0.0.1.tar.gz`

3. **质量验证通过**
   - ✅ `twine check` 验证通过
   - ✅ 独立环境安装测试通过
   - ✅ 功能测试通过（可以正常解析Move代码）

### 🚀 如何使用您的包

#### 方法1: 本地安装（推荐）
```bash
<code_block_to_apply_from>
```

#### 方法2: 发布到PyPI
```bash
# 上传到Test PyPI（测试用）
twine upload --repository testpypi dist/*

# 上传到PyPI（正式发布）
twine upload dist/*
```

#### 方法3: 从源码安装
```bash
# 开发模式安装
pip install -e .
```

### 📋 包信息
- **包名**: `tree-sitter-move`
- **版本**: `0.0.1`
- **支持Python**: 3.8+
- **依赖**: `tree-sitter>=0.21.0`
- **许可证**: Apache License 2.0

### 🧪 使用示例
```python
import tree_sitter_move as ts_move
from tree_sitter import Language, Parser

# 创建解析器
move_language = Language(ts_move.language())
parser = Parser(move_language)

# 解析Move代码
code = "module 0x1::hello { public fun world() {} }"
tree = parser.parse(bytes(code, "utf8"))

print("✅ 解析成功!" if not tree.root_node.has_error else "❌ 解析失败")
```

### 📖 完整文档
详细的安装和使用指南已保存在 `PACKAGING_GUIDE.md` 文件中。

现在您的tree-sitter-move包已经可以：
- ✅ 本地安装使用
- ✅ 分发给其他用户
- ✅ 上传到PyPI供全球用户使用

**🎊 恭喜！您已经成功创建了一个可分发的Python包！**
