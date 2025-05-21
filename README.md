# Codebase Consolidator

## Overview
This Bash script helps prepare large codebases for AI analysis by consolidating files into a single text file. It's specifically designed to optimize token usage when feeding code into AI assistants (like Claude, GPT, etc.) for codebase analysis and questions.

## Purpose
When working with AI assistants on large code projects, token limitations can prevent uploading the entire codebase. This tool solves that problem by:
- Including all text-based files with their content (code, markdown, config files, etc.)
- Only listing media file paths without their binary content
- Creating a single, well-formatted text file that provides the AI with a complete view of your codebase structure

## Usage
```bash
./codebase_consolidator.sh <directory>
```

## How It Works
1. Recursively traverses the specified directory
2. For code and text files: Includes both file path and complete content
3. For media files (gif, jpg, jpeg, png, psd, svg): Includes only the file path to save tokens
4. Creates a single output file (`combined_files.txt`) containing the entire codebase

## Best Practices for AI Analysis
- Run this script on your project's root directory
- Upload the resulting `combined_files.txt` to your AI assistant
- Ask specific questions about your code structure, implementation details, or potential improvements
- Reference specific files or components in your questions

## Example Workflow
1. Run: `./codebase_consolidator.sh ~/projects/my-web-app`
2. Upload the generated `combined_files.txt` to your AI assistant
3. Ask: "Can you explain how the authentication flow works across the codebase?"

## Notes
- Consider excluding build directories, node_modules, or other large generated directories to reduce token usage
- For very large projects, you might want to run this on specific subdirectories
- The script preserves file paths, making it easy for the AI to understand project structure
- Binary and media files are just listed by path to prevent token waste on non-textual content