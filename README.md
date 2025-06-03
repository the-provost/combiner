# Codebase Consolidator

## Overview
This Bash script helps prepare large codebases for AI analysis by consolidating files into a single text file. It's specifically designed to optimize token usage when feeding code into AI assistants (like Claude, GPT, etc.) for codebase analysis and questions.

## Purpose
When working with AI assistants on large code projects, token limitations can prevent uploading the entire codebase. This tool solves that problem by:
- Including all text-based files with their content (code, markdown, config files, etc.)
- Only listing media file paths without their binary content
- Creating a single, well-formatted text file that provides the AI with a complete view of your codebase structure

## Use Cases

### Code Analysis & Documentation
- Creating comprehensive codebases for AI code review tools like Claude or ChatGPT
- Generating documentation snapshots of entire projects
- Code auditing and analysis across multiple files
- Creating backups of text-based project files

### Content Management
- Consolidating documentation spread across multiple files
- Creating searchable archives of text content
- Merging configuration files for analysis
- Collecting logs or data files for processing

### Development Workflows
- Preparing codebases for LLM-assisted refactoring or debugging
- Creating training datasets from code repositories
- Generating comprehensive project overviews for new team members
- Archiving project states at specific milestones

### Data Processing
- Aggregating CSV, JSON, or other structured data files
- Collecting configuration files for batch processing
- Merging scattered text files into single documents

## Installation

### Make it globally available (Recommended)
1. Create a local bin directory and move the script:
   ```bash
   mkdir -p ~/bin
   mv combiner.sh ~/bin/combiner
   chmod +x ~/bin/combiner
   ```

2. Add ~/bin to your PATH (if not already there):
   ```bash
   echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
   source ~/.bashrc
   ```

3. Now you can use `combiner` from anywhere:
   ```bash
   combiner /path/to/your/project
   ```

### Alternative: System-wide installation
```bash
sudo mv combiner.sh /usr/local/bin/combiner
sudo chmod +x /usr/local/bin/combiner
```

### Alternative: Shell alias
```bash
echo "alias combiner='/path/to/your/combiner.sh'" >> ~/.bashrc
source ~/.bashrc
```

## Usage
```bash
combiner <directory>
```

Example:
```bash
combiner ~/projects/my-web-app
```

## How It Works
1. Recursively traverses the specified directory
2. For code and text files: Includes both file path and complete content
3. For media files (gif, jpg, jpeg, png, psd, svg, eps): Includes only the file path to save tokens
4. Creates a single output file (`combined_files.txt`) containing the entire codebase

## Best Practices for AI Analysis
- Run this script on your project's root directory
- Upload the resulting `combined_files.txt` to your AI assistant
- Ask specific questions about your code structure, implementation details, or potential improvements
- Reference specific files or components in your questions

## Example Workflow
1. Run: `combiner ~/projects/my-web-app`
2. Upload the generated `combined_files.txt` to your AI assistant
3. Ask: "Can you explain how the authentication flow works across the codebase?"

## Contributing
Contributions are welcome! Please:
- Fork the repository
- Create a feature branch
- Submit a pull request with a clear description
- Ensure your contributions are compatible with GPL v3

## License
This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

**What this means:**
- ✅ You can use, modify, and distribute this software
- ✅ You can use it commercially
- ⚠️ Any derivative works must also be licensed under GPL v3
- ⚠️ You must include the license and copyright notice
- ⚠️ You must disclose the source code of any distributed modifications

## Notes
- Consider excluding build directories, node_modules, or other large generated directories to reduce token usage
- For very large projects, you might want to run this on specific subdirectories
- The script preserves file paths, making it easy for the AI to understand project structure
- Binary and media files are just listed by path to prevent token waste on non-textual content