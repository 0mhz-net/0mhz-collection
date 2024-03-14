#!/bin/bash

if ! command -v xmllint &> /dev/null; then
    echo "xmllint could not be found. Please install it."
    # Optionally, exit the script if xmllint is required for further operations
    exit 1
fi

MGL_DIR=$(realpath ./mgls)  # Default MGL directory relative to the script's location
MEDIA_BASE=$HOME
TARGET_DIR=$(realpath ./target)
CONFIG_FILE=$(realpath config/AO486.CFG"")

echo "Using MEDIA_DIR: $MEDIA_DIR"
echo "Using TARGET_DIR: $TARGET_DIR"
echo "Adding configuration file from: $CFG_FILE_PATH"

# Clear out the old TARGET_DIR and create a fresh one
echo "Preparing the target directory..."
if [ -d "$TARGET_DIR" ]; then
    rm -rf "$TARGET_DIR"
fi

rm -fr $TARGET_DIR
mkdir -p "$TARGET_DIR"
mkdir -p "$TARGET_DIR/zips"

find "$MGL_DIR" -type f -name "*.mgl" | while read file; do
  echo "MGL File: $file"

  # get the game contents directory name
  modified_xml=$(sed 's/&/\&amp;/g' "$file")
  temp_path=$(echo "$modified_xml" | xmllint --xpath 'string(//file[1]/@path)' -)
  parent_dir_path=$(dirname "$temp_path")

  # create a source directory with the media base and game content name
  source_dir="$MEDIA_BASE/$parent_dir_path"
  # create a path where to copy the files needed for a zip distribution of the game
  new_target=$TARGET_DIR/tmp/games/ao486/$parent_dir_path

  # create zip file name for distribution
  zip_file=$(basename "$file" | cut -d. -f1).zip

  echo "Source Directory: $source_dir"
  echo "Target Directory: $new_target"
  echo "Zip archive: $zip_file"

  # clean out last tmp contents
  rm -fr $TARGET_DIR/tmp

  # copy media contents for current game/media
  mkdir -p "$new_target"
  cp -r "$source_dir"/* "$new_target"

  # copy MiSTer ao486 core config
  mkdir -p "$TARGET_DIR/tmp/config"
  cp $CONFIG_FILE "$TARGET_DIR/tmp/config"

  # copy MGL file
  mkdir -p "$TARGET_DIR/tmp/_DOS Games"
  cp "$file" "$TARGET_DIR/tmp/_DOS Games"

  # shellcheck disable=SC2164
  cd "$TARGET_DIR/tmp"
  zip -r "$TARGET_DIR/zips/$zip_file" *
  # shellcheck disable=SC2164
  cd "$TARGET_DIR"
  echo "---------------------------------------------------------------------------"
done
