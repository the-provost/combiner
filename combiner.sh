#!/bin/bash

# Check for correct arguments
if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>" >&2
    exit 1
fi

# Validate input directory
if [ ! -d "$1" ]; then
    echo "Error: Directory $1 does not exist" >&2
    exit 1
fi

# Set paths and initialize
root_dir=$(realpath "$1")
output_file="$root_dir/combined_files.txt"
first_file=1

# Clear/create output file
> "$output_file"

# Skip common directories that shouldn't be included
should_skip_directory() {
    local dir_name=$(basename "$1")
    case "$dir_name" in
        # Node.js
        node_modules|.npm|npm-debug.log*|yarn-debug.log*|yarn-error.log*|.pnpm-debug.log*)
            return 0
            ;;
        # Python
        __pycache__|*.pyc|*.pyo|*.pyd|.Python|build|develop-eggs|dist|downloads|eggs|.eggs|lib|lib64|parts|sdist|var|wheels|*.egg-info|.installed.cfg|*.egg|.venv|venv|env|ENV|env.bak|venv.bak)
            return 0
            ;;
        # Laravel/PHP
        vendor|storage/logs|storage/framework|storage/app|bootstrap/cache|.env.backup|Homestead.json|Homestead.yaml|npm-debug.log|yarn-error.log)
            return 0
            ;;
        # General development
        .git|.svn|.hg|.bzr|CVS|.DS_Store|Thumbs.db|.vscode|.idea|*.swp|*.swo|*~|.cache|.tmp|tmp|temp|logs|log|coverage|.nyc_output|.sass-cache)
            return 0
            ;;
        # Build artifacts
        build|dist|target|out|bin|obj|release|debug|public/build|public/hot|public/storage)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Recursive directory processor
process_directory() {
    local dir="$1"
    
    # Process files first (non-hidden)
    for file in "$dir"/*; do
        if [ -f "$file" ] && [ "$file" != "$output_file" ]; then
            # Get file extension
            extension="${file##*.}"
            extension=$(echo "$extension" | tr '[:upper:]' '[:lower:]')
            
            # Check if it's a media file
            if [[ "$extension" =~ ^(gif|jpg|jpeg|png|psd|svg|eps)$ ]]; then
                relative_path="${file#$root_dir/}"
                
                if [ $first_file -eq 1 ]; then
                    printf "%s\n" "$relative_path" >> "$output_file"
                    first_file=0
                else
                    printf "\n%s\n" "$relative_path" >> "$output_file"
                fi
                # No content is added, just the filename
            else
                # For non-media files, include both title and content as before
                relative_path="${file#$root_dir/}"
                
                if [ $first_file -eq 1 ]; then
                    printf "%s\n\n" "$relative_path" >> "$output_file"
                    first_file=0
                else
                    printf "\n\n\n%s\n\n" "$relative_path" >> "$output_file"
                fi
                
                cat "$file" >> "$output_file"
            fi
        fi
    done

    # Then process subdirectories (non-hidden) with exclusions
    for file in "$dir"/*; do
        if [ -d "$file" ] && ! should_skip_directory "$file"; then
            process_directory "$file"
        fi
    done
}

# Start processing from root directory
process_directory "$root_dir"

# Get results
line_count=$(wc -l < "$output_file")
skipped_dirs=$(find "$root_dir" -type d \( -name "node_modules" -o -name "vendor" -o -name ".git" -o -name "__pycache__" -o -name "build" -o -name "dist" \) 2>/dev/null | wc -l)

# Output final information
echo "Success. Number of lines: $line_count"
echo "Skipped directories: $skipped_dirs"
echo "File: $output_file"

exit 