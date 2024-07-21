#!/bin/bash

# New SSH public key
NEW_SSH_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyOZ7V8r1omOcStVy4Yl45Yr6..."

# Function to update the authorized_keys file
update_authorized_keys() {
    local user="$1"
    local home_dir

    # Get the home directory of the user
    home_dir=$(eval echo "~$user")

    # Check if the home directory exists
    if [ ! -d "$home_dir" ]; then
        echo "Home directory for user $user does not exist, skipping."
        return
    fi

    local ssh_dir="$home_dir/.ssh"
    local authorized_keys="$ssh_dir/authorized_keys"

    # Backup existing authorized_keys if it exists
    if [ -f "$authorized_keys" ]; then
        cp "$authorized_keys" "${authorized_keys}.bak"
    fi

    # Remove existing authorized_keys file
    rm -f "$authorized_keys"

    # Ensure the .ssh directory exists
    mkdir -p "$ssh_dir"

    # Add the new SSH key
    echo "$NEW_SSH_KEY" > "$authorized_keys"

    # Set appropriate permissions
    chown -R "$user:$user" "$ssh_dir"
    chmod 700 "$ssh_dir"
    chmod 600 "$authorized_keys"
}

# Update authorized_keys for root, ubuntu, and admin users
for user in root ubuntu admin; do
    update_authorized_keys "$user"
done

echo "SSH keys updated successfully."
