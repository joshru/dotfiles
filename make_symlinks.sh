#!/bin/bash
####################################################################################################
# File: make_symlinks.sh
# Description: This script creates symlinks from the home directory to any desired dot-files in
#   ~/dotfiles
# Notes:
#   - This script was developed from tafryn's "makesymlinks.sh" symlink creation script used in
#       tafryn's dotfiles repository. This repository can be found at the following address:
#       https://github.com/tafryn/dotfiles
####################################################################################################

########## Variables ##########

dir=~/dotfiles          # dotfiles directory
old_dir=~/dotfiles_old  # backup directory for existing dotfiles
change_counter=0        # count of the number of files changed

files="vimrc vim"       # list of files and folders to symlink in the home directory

########## Actions ##########

# if old_dir does not already exist, create it
if [ ! -e $old_dir ]; then
    echo -n "Creating $old_dir for backup of any existing dotfiles in home directory  ..."
    mkdir -p $old_dir
    echo " done."
fi

# change to the Dotfiles directory
echo -n "Changeing to the $dir directory ..."
cd $dir
echo " done."

# for the files in files, backup the existing file, create the symlink, and track the number of
#   changed files
for file in $files; do
    # if there is a differece between the file in the home directory and the file in dir, back the
    #   file up if it exists, create the symlink, and increment the number of altered files
    if ! diff -rq ~/.$file $dir/.$file; then
        # if the file exists, back it up to old_dir
        if [ -e ~/.$file ]; then
            echo -n "Moving existing .$file from ~ to $old_dir ..."
            mv ~/.$file $old_dir
            echo " done."
        fi
        
        # create the symlink
        echo -n "Creating symlink to .$file in home directory ..."
        ln -s $dir/.$file ~/.$file
        echo " done."
        
        # increment the count of changed files
        change_counter=$((change_counter+1))
    fi
done

# report how many files were changed
echo "Changed $change_counter files."

