#!/bin/bash

# Path to the colors configuration file
CONFIG_FILE="$HOME/.config/i3/colorschemes/catppuccin/latte.conf"

# Read the colors from the config file and export as environment variables
eval $(awk -F' = ' '/^base|mantle|crust|text|subtext0|subtext1|surface0|surface1|surface2|overlay0|overlay1|overlay2|blue|red|green|yellow|peach|mauve/ { gsub(/\[colors\]/, ""); printf("export %s=%s\n", $1, $2) }' $CONFIG_FILE)
