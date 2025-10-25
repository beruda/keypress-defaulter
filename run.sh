#!/bin/zsh

function extract_app_id() {
    APP_NAME=$1
    # Remove any backslashes that were used for escaping spaces
    APP_NAME_CLEAN=${APP_NAME//\\/}
    IDish=$(cat "/Applications/$APP_NAME_CLEAN.app/Contents/Info.plist" | grep -E -A1 "CFBundleIdentifier" | grep "string" | grep -o "\>.*\<")
    ID=$IDish[2,-3]
    echo $ID
}

function parse_apps() {
    APP_NAMES=("$@")
    APP_IDS=()
    for APP_NAME in "${APP_NAMES[@]}"; do
        APP_ID=$(extract_app_id $APP_NAME)
        APP_IDS+=($APP_ID)
    done
    echo $APP_IDS
}

# Process all command line arguments
if [ $# -eq 0 ]; then
    echo "\e[31mUsage: $0 <app_name1> <app_name2> ...\e[0m"
    exit 1
fi

# Check if the global ApplePressAndHoldEnabled is set
if defaults read -g ApplePressAndHoldEnabled > /dev/null 2>&1; then
    echo "\e[31mGlobal ApplePressAndHoldEnabled is set, deleting...\e[0m"
    echo "\e[34mrunning\e[0m: defaults delete -g ApplePressAndHoldEnabled\n"
    defaults delete -g ApplePressAndHoldEnabled
else
    echo "\e[32mGlobal ApplePressAndHoldEnabled is already unset globally\e[0m\n"
fi

APP_IDS=($(parse_apps "$@"))
for APP_ID in "${APP_IDS[@]}"; do
    # Check if the ApplePressAndHoldEnabled is already disabled for the app
    if defaults read $APP_ID ApplePressAndHoldEnabled > /dev/null 2>&1; then
        CURRENT_VALUE=$(defaults read $APP_ID ApplePressAndHoldEnabled 2>/dev/null)
        if [ "$CURRENT_VALUE" = "0" ] || [ "$CURRENT_VALUE" = "false" ]; then
            echo "\e[33mApplePressAndHoldEnabled is already disabled for $APP_ID\e[0m\n"
            continue
        fi
    fi

    # Disable the ApplePressAndHoldEnabled for the app
    echo "\e[32mDisabling ApplePressAndHoldEnabled for $APP_ID\e[0m"
    echo "\e[34mrunning\e[0m: defaults write $APP_ID ApplePressAndHoldEnabled -bool false\n"
    defaults write $APP_ID ApplePressAndHoldEnabled -bool false
done