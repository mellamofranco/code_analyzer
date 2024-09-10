#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the name of the root directory
ROOT_DIR_NAME="$(basename "$SCRIPT_DIR")"

# Output file path with root directory name as a subname
OUTPUT_FILE="$SCRIPT_DIR/files_list_${ROOT_DIR_NAME}.txt"

# Function to print the tree structure
print_tree() {
    local folder="$1"
    local prefix="$2"
    local items=("$folder"/*)

    # Filter out non-existing paths (if folder is empty, items will include the wildcard itself)
    items=("${items[@]/*\/\*}")

    # Iterate over each item in the current directory
    for i in "${!items[@]}"; do
        local item="${items[$i]}"
        local base_item="$(basename "$item")"

        # Determine the connector
        if [ "$i" -eq $(( ${#items[@]} - 1 )) ]; then
            local connector="└──"
            local new_prefix="${prefix}    "
        else
            local connector="├──"
            local new_prefix="${prefix}│   "
        fi

        # Print the current item
        echo "${prefix}${connector} $base_item" >> "$OUTPUT_FILE"

        # Recursively process subdirectories
        if [ -d "$item" ]; then
            print_tree "$item" "$new_prefix"
        fi
    done
}

# Initialize the output file
echo "$ROOT_DIR_NAME" > "$OUTPUT_FILE"

# Start printing the tree structure from the script directory
print_tree "$SCRIPT_DIR" ""

# Optionally, print a message indicating completion
echo "Readable tree structure of all files and directories in $SCRIPT_DIR has been saved to $OUTPUT_FILE"
