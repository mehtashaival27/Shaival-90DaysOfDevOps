
#!/bin/bash

# This is the Week 3 Shell Scripting assignment.

# Function to create a new user
create_user() {
    echo "Creating the User"
    read -p "Enter the Username: " username

    count=$(cat /etc/passwd | grep -w "$username" | wc -l)
    if [ "$count" -gt 0 ]; then
        echo "Error: User $username already exists."
    else
        sudo useradd "$username"
        echo "User $username created successfully."
    fi
}

# Function to delete a user
delete_user() {
    read -p "Enter the Username: " username

    count=$(cat /etc/passwd | grep -w "$username" | wc -l)
    if [ "$count" -gt 0 ]; then
        sudo userdel -r "$username" 2>/dev/null
        echo "User $username deleted successfully."
    else
        echo "Error: User $username does not exist."
    fi
}

# Function to reset a user's password
reset_password() {
    read -p "Enter the Username: " username

    count=$(cat /etc/passwd | grep -w "$username" | wc -l)
    if [ "$count" -gt 0 ]; then
        read -sp "Enter a new password for user $username: " password
        echo
        echo "$username:$(openssl passwd -1 "$password")" | sudo chpasswd
        echo "Password updated successfully."
    else
        echo "Error: User $username does not exist."
    fi
}

# Function to list all users
list_users() {
	echo "The List of Users are:"
    cat /etc/passwd | awk -F':' '{ print $1 }'
}

# Help function to show options
help() {
    echo -e "Options:\n"
    echo "-c  | --create  : Create a new user"
    echo "-d  | --delete  : Delete a user"
    echo "-r  | --reset   : Reset a user's password"
    echo "-l  | --list    : List all users"
    echo "-h  | --help    : Show this help message"
}

# Main loop
while true; do
    help
    read -p "Enter choice: " choice
    case $choice in
        -c | --create)  create_user ;;
        -d | --delete)  delete_user ;;
        -r | --reset)   reset_password ;;
        -l | --list)    list_users ;;
        -h | --help)    help ;;
        *) echo "Invalid option. Try again." ;;
    esac
done
