# Iterate over each zip file and extract it, overwriting duplicate files
for file in *.zip; do
    unzip -o "$file"
done

# Optionally delete the zip files?

