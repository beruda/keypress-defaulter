# Keypress Defaulter

A simple shell script to disable Apple's press-and-hold feature (ApplePressAndHoldEnabled) for specific applications on macOS.

## What it does

This script:
- Removes the global ApplePressAndHoldEnabled setting
- Disables ApplePressAndHoldEnabled for each specified application
- Provides colored output to show what actions are being taken
- Skips applications that already have the setting disabled

## Usage

```bash
./run.sh <app_name1> <app_name2> ...
```

### Examples

```bash
# Disable for single app
./run.sh Safari

# Disable for multiple apps
./run.sh Safari Chrome Firefox

# Apps with spaces in their names
./run.sh "Jetbrains Toolbox" "Sublime Text" "GraphQL Playground"
```

## How it works

1. **Global cleanup**: Removes any global ApplePressAndHoldEnabled setting
2. **App ID extraction**: For each app name, extracts the bundle identifier from the app's Info.plist
3. **Setting application**: Sets `ApplePressAndHoldEnabled` to `false` for each app's bundle identifier

## Requirements

- macOS
- zsh shell
- Applications must be installed in `/Applications/`

## Output

The script provides colored output:
- 🔴 Red: Global settings being deleted
- 🟡 Yellow: Apps already disabled (skipped)
- 🔵 Blue: Commands being executed
- 🟢 Green: Successful operations

## Notes

- The script automatically handles app names with spaces
- It skips apps that already have ApplePressAndHoldEnabled disabled
- All `defaults` commands are executed (not just displayed)
