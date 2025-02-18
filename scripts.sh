#!/bin/bash

<<help
This is a Shell Scripting File
help

echo "======Step 1: Account Creation========="

# Prompt to enter the username
read -p "Enter the Username:" username

# Check if username is provided or not. "-z" check if the string is empty or not.
if [[ -z "$username" ]]; then
	echo "Error: Username is not provided"
	exit 1
fi

# Check if username already exists in /etc/passwd or not
if grep -q "$username" /etc/passwd; then
	echo "Error: User already exists"
	exit 1
fi

# Add user in home directory. Hence, user will be at two locations. 1. cat/etc/passwd 2. cd /home/$user
sudo useradd -m "$username"

# Prompt to enter the password
read -p "Enter the password: " password

# Set the password for the user
echo "$username:$password" | sudo chpasswd

# Confirm that user is added to the system.
echo -e "$username has been added to the System"


echo "==========Account Creation is Completed======="

echo "========Step 2: Account Deletion======"

read -p "Enter the username to check it exists before deleting" username

# Check if username is provided or not. "-z" check if the string is empty or not.
if [[ -z "$username" ]]; then
	echo "Error: Username is not provided"
	exit 1
fi


if grep -q "$username" /etc/passwd; then
	echo "User $username exist and can be deleted"
	sudo userdel -r "$username" >/dev/null 
	echo "User $username has been deleted"

else
	echo "Error: User $username does not exist"
	exit 1
fi

echo "========Account Deletion is completed====="

echo "=======Step 3: Password Reset========"

read -p "Enter the Username:" username

count=$( cat /etc/passwd | grep $username | wc -l )
        if [ "$count" -gt 0 ]; then
                read -sp "Enter a new password for user $username:" passwd
                echo "$username:$(openssl passwd -1 "$password")" |sudo chpasswd
                echo
                echo "Password updated successfully"
        else
                echo "$username not exist"
        fi


