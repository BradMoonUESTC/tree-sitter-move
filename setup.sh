#!/bin/bash

# Tree-sitter Move Parser Installation Script

echo "🚀 Tree-sitter Move Parser Installation Script"
echo "=============================================="

# Check Python version
echo "🔍 Checking Python version..."
if ! command -v python3 &> /dev/null; then
    echo "❌ Error: python3 command not found"
    echo "Please install Python 3.8+ first"
    exit 1
fi

PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
echo "✅ Python version: $PYTHON_VERSION"

# Create virtual environment
echo ""
echo "📦 Creating virtual environment..."
if [ -d "venv" ]; then
    echo "⚠️  Virtual environment already exists, skipping creation"
else
    python3 -m venv venv
    echo "✅ Virtual environment created successfully"
fi

# Activate virtual environment
echo ""
echo "🔧 Activating virtual environment..."
source venv/bin/activate

# Upgrade pip
echo ""
echo "⬆️  Upgrading pip..."
python -m pip install --upgrade pip --trusted-host pypi.org --trusted-host files.pythonhosted.org

# Install dependencies
echo ""
echo "📚 Installing dependencies..."
pip install tree-sitter --trusted-host pypi.org --trusted-host files.pythonhosted.org --trusted-host pypi.python.org

# Install current project
echo ""
echo "📦 Installing tree-sitter-move parser..."
pip install -e .

# Run test
echo ""
echo "🧪 Running test..."
python move_parser_demo.py

echo ""
echo "🎉 Installation completed!"
echo ""
echo "Usage:"
echo "1. Activate virtual environment: source venv/bin/activate"
echo "2. Run demo script: python move_parser_demo.py"
echo "3. View documentation: cat README.md"
echo ""
echo "Start using Tree-sitter Move Parser!"
