#!/bin/bash
read -p "Enter the path to directory from which to restore (~/backups by default): " backup_dir

if [ -z "$backup_dir" ]; then
    backup_dir="$HOME/backups"
else
    backup_dir="${backup_dir/#\~/$HOME}"
fi

restored_read_message="Enter the name of the directory you want to restore (enter nothing to view available restores): "

while [ -z "$restored_dir" ]; do
    read -p "$restored_read_message" restored_dir

    if [ -z "$restored_dir" ]; then
        all_available_restores=("$backup_dir"/*_backup_[0-9]*.tar.gz)
        declare -A available_names
        for file in "${all_available_restores[@]}";do
            name=$(basename $(echo "$file" | cut -d "_" -f1))
            available_names["$name"]=1
        done
        available_restores=("${!available_names[@]}")
        for ((i=0; i<${#available_restores[@]}; i++)); do
            echo "$i: ${available_restores[i]}"
        done
        restored_read_message="Enter the name (or the number) of the directory you want to restore (enter nothing to view available restores): "
    elif [[ "$restored_dir" =~ [0-9]* ]] && [[ "$restored_read_message" =~ "number" ]] && [ "$restored_dir" -lt "${#available_restores[@]}" ] && [ "$restored_dir" -ge 0 ]; then
        restored_dir=${available_restores["$restored_dir"]}
    fi
done
read -p "Enter the path to directory in which to restore (~ by default): " restore_dir

if [ -z "$restore_dir" ]; then
    restore_dir="$HOME"
else
    restore_dir="${restore_dir/#\~/$HOME}"
fi
mkdir -p "$restore_dir"

latest_matching_backup=$(ls "$backup_dir" | grep "${restored_dir}_backup_[0-9]*.tar.gz" | sort -t_ -k3n | tail -n1)
if [ -n "$latest_matching_backup" ]; then
    echo "Restoring ${restored_dir} to ${restore_dir}:"
    tar -xzvf "$backup_dir/$latest_matching_backup" -C "$restore_dir"
else
    echo "No backups were found"
fi

