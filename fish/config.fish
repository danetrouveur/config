# Example Fish configuration

# Set the default editor to nano
set -Ux EDITOR nano

# Add custom paths to the PATH variable
set -Ux PATH $HOME/bin /usr/local/bin $PATH

zoxide init fish | source
