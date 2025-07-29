#!/usr/bin/env python3
"""
Comprehensive Move Language Parser Test Script
Tests parsing capabilities on multiple Move code files
"""

import os
import glob
from pathlib import Path

def print_separator(title, char="=", width=60):
    """Print separator"""
    print(f"\n{char * width}")
    print(f"{title:^{width}}")
    print(f"{char * width}")

def print_subseparator(title, char="-", width=40):
    """Print sub-separator"""
    print(f"\n{char * width}")
    print(f" {title}")
    print(f"{char * width}")

def analyze_node(node, depth=0, max_depth=3):
    """Recursively analyze AST nodes"""
    indent = "  " * depth
    result = f"{indent}├─ {node.type}"
    
    if hasattr(node, 'text') and node.text:
        text_preview = node.text.decode('utf-8')[:50].replace('\n', '\\n')
        if len(text_preview) == 50:
            text_preview += "..."
        result += f" → '{text_preview}'"
    
    print(result)
    
    if depth < max_depth and node.child_count > 0:
        for child in node.children:
            analyze_node(child, depth + 1, max_depth)

def test_move_file(file_path, parser):
    """Test single Move file"""
    print_subseparator(f"Testing file: {file_path}")
    
    try:
        # Read file content
        with open(file_path, 'r', encoding='utf-8') as f:
            code = f.read()
        
        print(f"📄 File size: {len(code)} characters")
        print(f"📄 Lines: {len(code.splitlines())} lines")
        
        # Show code preview
        lines = code.splitlines()
        preview_lines = min(10, len(lines))
        print(f"\n📝 Code preview (first {preview_lines} lines):")
        print("┌" + "─" * 50 + "┐")
        for i, line in enumerate(lines[:preview_lines], 1):
            line_preview = line[:45]
            if len(line) > 45:
                line_preview += "..."
            print(f"│ {i:2d} │ {line_preview:<45} │")
        if len(lines) > preview_lines:
            print(f"│ .. │ ... (omitted {len(lines) - preview_lines} lines) {'':<32} │")
        print("└" + "─" * 50 + "┘")
        
        # Parse code
        print("\n⚡ Starting parse...")
        tree = parser.parse(bytes(code, "utf8"))
        
        # Check parse result
        if tree.root_node.has_error:
            print("❌ Parse failed - syntax errors detected!")
            
            # Find error nodes
            def find_errors(node):
                errors = []
                if node.type == 'ERROR':
                    errors.append(node)
                for child in node.children:
                    errors.extend(find_errors(child))
                return errors
            
            error_nodes = find_errors(tree.root_node)
            print(f"🔍 Found {len(error_nodes)} error nodes:")
            
            for i, error_node in enumerate(error_nodes[:3], 1):  # Show max 3 errors
                start_point = error_node.start_point
                end_point = error_node.end_point
                print(f"   {i}. Error location: line {start_point.row + 1}, column {start_point.column + 1}")
                if error_node.text:
                    error_text = error_node.text.decode('utf-8')[:30]
                    print(f"      Error content: '{error_text}'")
        else:
            print("✅ Parse successful!")
            print(f"🌳 Root node type: {tree.root_node.type}")
            print(f"📊 Child node count: {tree.root_node.child_count}")
            
            # Show AST structure
            print(f"\n🌲 AST structure preview:")
            analyze_node(tree.root_node, max_depth=2)
            
            # Count node types
            def count_node_types(node):
                type_counts = {}
                def visit(n):
                    type_counts[n.type] = type_counts.get(n.type, 0) + 1
                    for child in n.children:
                        visit(child)
                visit(node)
                return type_counts
            
            node_types = count_node_types(tree.root_node)
            print(f"\n📈 Node type statistics:")
            for node_type, count in sorted(node_types.items()):
                print(f"   {node_type}: {count}")
        
        print(f"\n🎯 Test result: {'✅ Pass' if not tree.root_node.has_error else '❌ Fail'}")
        return not tree.root_node.has_error
        
    except Exception as e:
        print(f"❌ Test failed with exception: {e}")
        return False

def main():
    print_separator("🚀 Comprehensive Move Language Parser Test", "=", 70)
    
    try:
        # Import necessary modules
        import tree_sitter_move as ts_move
        from tree_sitter import Language, Parser
        
        # Create parser
        print("🔧 Initializing Move parser...")
        move_language = Language(ts_move.language())
        parser = Parser(move_language)
        
        print(f"✅ Parser created successfully!")
        print(f"📦 Language name: {move_language.name or 'move_on_aptos'}")
        
        # Find test files
        test_dir = "move_test_files"
        if not os.path.exists(test_dir):
            print(f"❌ Test directory '{test_dir}' not found")
            return
        
        move_files = glob.glob(os.path.join(test_dir, "*.move"))
        if not move_files:
            print(f"❌ No .move files found in '{test_dir}' directory")
            return
        
        print(f"\n🔍 Found {len(move_files)} Move files:")
        for i, file_path in enumerate(move_files, 1):
            print(f"   {i}. {os.path.basename(file_path)}")
        
        print_separator("Starting file tests", "=", 70)
        
        # Test each file
        test_results = {}
        for file_path in sorted(move_files):
            filename = os.path.basename(file_path)
            success = test_move_file(file_path, parser)
            test_results[filename] = success
        
        # Show summary
        print_separator("📊 Test Summary", "=", 70)
        
        total_files = len(test_results)
        passed_files = sum(1 for success in test_results.values() if success)
        failed_files = total_files - passed_files
        
        print(f"📈 Overall statistics:")
        print(f"   📁 Total files: {total_files}")
        print(f"   ✅ Tests passed: {passed_files}")
        print(f"   ❌ Tests failed: {failed_files}")
        print(f"   📊 Success rate: {(passed_files/total_files)*100:.1f}%")
        
        print(f"\n📋 Detailed results:")
        for filename, success in sorted(test_results.items()):
            status = "✅ Pass" if success else "❌ Fail"
            print(f"   {filename:25} → {status}")
        
        if failed_files == 0:
            print(f"\n🎉 All tests passed! Move parser is working correctly.")
        else:
            print(f"\n⚠️  {failed_files} files failed testing, which may be expected (e.g., syntax error test files).")
        
        print(f"\n✨ Move language parser testing completed!")
        
    except ImportError as e:
        print(f"❌ Import error: {e}")
        print("Please make sure tree-sitter-move package is installed")
        print("Run: pip install -e . to install")
    except Exception as e:
        print(f"❌ Other error: {e}")

if __name__ == "__main__":
    main() 