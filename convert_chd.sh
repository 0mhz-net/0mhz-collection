#!/bin/bash

# Define the directory to search in
SEARCH_DIR="$HOME/media"

# Function to convert a single file to CHD
convert_to_chd() {
  local file_path="$1"
  local extension="${file_path##*.}"
  local target_file="${file_path%.*}.chd"

  echo "Converting $file_path to $target_file..."
  if [[ "$extension" == "cue" ]]; then
    chdman createcd -i "$file_path" -o "$target_file"
  elif [[ "$extension" == "iso" ]]; then
    chdman createcd -i "$file_path" -o "$target_file"
  fi
}

# Export the function so it can be used by find -exec
export -f convert_to_chd

# Find and convert .cue and .iso files
find "$SEARCH_DIR" \( -iname "*.cue" -o -iname "*.iso" \) -exec bash -c 'convert_to_chd "$0"' {} \;

echo "Conversion process completed."
