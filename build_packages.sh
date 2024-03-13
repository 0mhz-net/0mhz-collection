#!/bin/bash

MGL_DIR=$(realpath ./mgls)  # Default MGL directory relative to the script's location
MEDIA_BASE=$HOME
TARGET_DIR=$(realpath ./target)

echo "Using MEDIA_DIR: $MEDIA_DIR"
echo "Using TARGET_DIR: $TARGET_DIR"
echo "Adding configuration file from: $CFG_FILE_PATH"

# Clear out the old TARGET_DIR and create a fresh one
echo "Preparing the target directory..."
if [ -d "$TARGET_DIR" ]; then
    rm -rf "$TARGET_DIR"
fi
mkdir -p "$TARGET_DIR"

find "$MGL_DIR" -type f -name "*.mgl" | while read file; do
  echo "File: $file"
  modified_xml=$(sed 's/&/\&amp;/g' "$file")
  file_path=$(echo "$modified_xml" | xmllint --xpath 'string(//file[1]/@path)' -)
  parent_dir_path=$(dirname "$file_path")
  source_dir="$MEDIA_BASE/$parent_dir_path"
  new_target=$TARGET_DIR/tmp/games/ao486/$parent_dir_path
  
  echo "File Path $file_path"
  echo "Parent dir path path: $parent_dir_path"
  echo "Source directory: $source_dir"
  echo "New targt: $new_target"
  echo "---------------------------------------------------------------------------"
  #mkdir -p $new_target
  #cp $MEDIA_DIR/$parent_dir/* $new_target
done
