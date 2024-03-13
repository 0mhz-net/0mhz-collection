#!/bin/bash

MGL_DIR="${MGL_DIR:-./mgls}"  # Default MGL directory relative to the script's location
MEDIA_DIR="${MEDIA_DIR:-$HOME}"  # Default media directory to the user's home directory
TARGET_DIR="${TARGET_DIR:-./zipped_files}"  # Default target directory for ZIP files
CFG_FILE_PATH="configuration/AO486.CFG"  # Path to the AO486.CFG file, kept relative

# Expand TARGET_DIR to an absolute path
TARGET_DIR=$(realpath "$TARGET_DIR")

echo "Using MEDIA_DIR: $MEDIA_DIR"
echo "Using TARGET_DIR: $TARGET_DIR"
echo "Adding configuration file from: $CFG_FILE_PATH"

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
    
    
    
    mkdir $TARGET/tmp/config
    mkdir -p $TARGET/tmp/games/ao486/$parent_dir_path
    
    echo "Attempting to COPY contents of: $MEDIA/$parent_dir_path/* into $TARGET_DIR/tmp/games/ao486/media/$parent_dir_path"
    
    cp $MEDIA/$parent_dir/* $TARGET_DIR/tmp/games/ao486/$parent_dir_path
    
    #echo "Attempting to ZIP contents of: $TARGET/tmp into $full_zip_path"
    
    # Change directory to MEDIA_DIR to keep relative paths in ZIP
    #(cd "$TARGET/tmp" && zip -r "$full_zip_path" "*") || {
    #    echo "Failed to create ZIP file: $full_zip_path"
    #    exit 1
    #}
    
    # Optionally, add the CFG file separately if it should be at the root of the zip
    zip -j "$full_zip_path" "$CFG_FILE_PATH" || {
        echo "Failed to add configuration file to ZIP: $full_zip_path"
        exit 1
    }
    
    rm -fr $TARGET/tmp
    echo "Successfully created ZIP file: $full_zip_path"
  else
    echo "Could not extract path for $file"
  fi
done

