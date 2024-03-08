#!/bin/bash

# Use this pseudocode to create a bash script that does the following:
#
# For each .mgl file in the directory "mgls":
#   - Create a temporary directory where we will collect the files for that
#     game. Inside it, do this:
#   - Create the directories "_DOS Games", "config" and "games/ao486/media"
#   - Copy the .mgl file into "_DOS Games"
#   - Copy the configuration/AO486.cfg file into the "config" directory
#   - Copy any file that corresponds to the entry name (minus the .mgl) from
#     the "vhds" directory into "games/ao486/media", regardless of file
#     extension
#   - Finally, zip up the contents of the temporary directory, name it the same
#     as the .mgl file, but with .zip as extension instead of .mgl, and move
#     the zip file to the "output" directory


# Define directories
INPUT_DIR="mgls"
OUTPUT_DIR="output"
TMP_DIR="tmp"
VHDS_DIR="vhds"
CONFIG_FILE="configuration/AO486.CFG"

# Loop through each .mgl file in the input directory
for file in "$INPUT_DIR"/*.mgl; do
    # Extract the filename without extension
    filename=$(basename "$file" .mgl)

    # Create temporary directory
    mkdir -p "$TMP_DIR/$filename"
    cd "$TMP_DIR/$filename" || exit

    # Create necessary directories
    mkdir -p "_DOS Games" "config" "games/ao486/media"

    # Copy .mgl file to _DOS Games directory
    cp "../../$file" "_DOS Games"

    # Copy configuration file to config directory
    cp "../../$CONFIG_FILE" "config"

    # Check if corresponding files exist in vhds directory
    vhds_files=$(ls "../../$VHDS_DIR/$filename"* 2>/dev/null)
    if [ -n "$vhds_files" ]; then
        cp "../../$VHDS_DIR/$filename"* "games/ao486/media"
    fi

    # Zip up contents of temporary directory
    zip -r "../../$OUTPUT_DIR/$filename.zip" .

    # Move back to the main directory
    cd ../../ || exit

    # Remove temporary directory
    rm -rf "$TMP_DIR/$filename"
done