#!/usr/bin/env bash

# Check if directory is provided
if [ $# -eq 0 ]; then
    echo "Please provide a directory path."
    exit 1
fi

EXTENSION_NAME=$1

# Trap signals to ensure clean exit
cleanup() {
    echo "Stopping script..."
    kill -9 $BLENDER_PID 2>/dev/null
    exit 0
}
trap cleanup SIGINT SIGTERM

# Function to run Blender with the extension
run_blender() {
    rm dist/$EXTENSION_NAME.zip
    zip -r dist/$EXTENSION_NAME.zip $EXTENSION_NAME

    # find where the add-on is installed outside user_default
    SCRIPTS=$(blender -b --python-expr "import bpy; print(bpy.utils.user_resource('SCRIPTS'))" | sed -n '1p')

    # delete it
    rm -rf $SCRIPTS/addons/$EXTENSION_NAME

    clear

    # reinstall it
    blender --factory-startup --command extension install-file -r user_default $PWD/dist/$EXTENSION_NAME.zip
    
    blender &
    BLENDER_PID=$!
}

# Initial run
run_blender

# Watch for file changes
while inotifywait -r -e modify,create,delete $EXTENSION_NAME; do
    # Kill previous Blender instance
    kill -9 $BLENDER_PID 2>/dev/null

    # Rerun Blender
    run_blender
done