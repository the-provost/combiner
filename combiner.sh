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
            if [[ "$extension" =~ ^(gif|jpg|jpeg|png|psd|svg)$ ]]; then
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
    # Then process subdirectories (non-hidden)
    for file in "$dir"/*; do
        if [ -d "$file" ]; then
            process_directory "$file"
        fi
    done
}
# Start processing from root directory
process_directory "$root_dir"
# Get results
line_count=$(wc -l < "$output_file")
# Output final information
echo "Success. Number of lines: $line_count"
echo "File: $output_file"
exit 0