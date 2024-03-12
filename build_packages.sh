#!/bin/bash

MGL_DIR="${MGL_DIR:-./mgls}"  # Default MGL directory relative to the script's location
MEDIA_DIR="${MEDIA_DIR:-$HOME}"  # Default media directory to the user's home directory
TARGET_DIR="${TARGET_DIR:-./target}"  # Default target directory for ZIP files, relative to the script's execution location

# Expand TARGET_DIR to an absolute path
TARGET_DIR=$(realpath "$TARGET_DIR")

echo "Using MEDIA_DIR: $MEDIA_DIR"
echo "Using TARGET_DIR: $TARGET_DIR"

# Clear out the old TARGET_DIR and create a fresh one
echo "Preparing the target directory..."
if [ -d "$TARGET_DIR" ]; then
    rm -rf "$TARGET_DIR"
fi
mkdir -p "$TARGET_DIR"

if ! command -v xmllint &> /dev/null; then
    echo "xmllint could not be found. Please install xmllint to use this script."
    exit 1
fi

if ! command -v zip &> /dev/null; then
    echo "zip could not be found. Please install zip to use this script."
    exit 1
fi

if [ ! -d "$MGL_DIR" ]; then
  echo "MGL directory does not exist: $MGL_DIR"
  exit 1
fi

find "$MGL_DIR" -type f -name "*.mgl" | while read file; do
  modified_xml=$(sed 's/&/\&amp;/g' "$file")
  
  file_path=$(echo "$modified_xml" | xmllint --xpath 'string(//file[1]/@path)' -)
  
  if [ -n "$file_path" ]; then
    parent_dir_path=$(dirname "$file_path")
    base_name=$(basename "$parent_dir_path")
    zip_file_name="${base_name}.zip"
    
    full_zip_path="$TARGET_DIR/$zip_file_name"
    
    echo "Attempting to ZIP contents of: $MEDIA_DIR/$parent_dir_path into $full_zip_path"
    
    (cd "$MEDIA_DIR" && zip -r "$full_zip_path" "$parent_dir_path") || {
        echo "Failed to create ZIP file: $full_zip_path"
        exit 1
    }
    
    echo "Successfully created ZIP file: $full_zip_path"
  else
    echo "Could not extract path for $file"
  fi
done

