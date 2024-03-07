base_dir=$(pwd)
archive_base="$base_dir/configs"
archive=$(pwd)/configs.zip

find . -maxdepth 1 -type d -printf "%f\n" | while read dir; do
    echo "Found directory: $dir"
    cd $dir
    zip -r $archive .
    cd ..
done

