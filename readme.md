# Example Blender Dev Environment

A quick little setup that makes Blender add-on development a smidgen less annoying.

## Requirements

- Blender. Tested with 4.3.2.

## Process

Run the `dev.sh` shell script like this: `./dev.sh my_example_extension` - the script will then "build" (zip up) the extension in `my_example_extension` and drop it in `dist`. It'll then delete any existing global install of the extension in Blender (if it exists), and reinstall it into the `user_default` repo.

If you change any files in your extension directory, Blender will be closed, the extension re-built, and then Blender restarted with the new version installed. You'll be able to test it immediately.

If you save the opened Blender file, it'll create a `default.blend` in this directory. You can persist changes this way and keep your project between extension changes.

## Structure

```
- dist/ // directory of ready-to-install extensions
  - my_example_extension.zip // the zip file someone needs to install manually via their preferences, to use your add-on
- my_example_extension/ // example extension. Partially taken from the Blender wiki, but with an added example for python dependencies
  - wheels/ // Python dependencies in the form of wheel files
    - packaging-24.2-py3-none-any.whl // Example dependency, imported in the `__init__.py`
  - __init__.py // your add-on's init script. This gets called by Blender and allows registration of your add-on
  - blender_manifest.toml // meta data
```

## Python dependencies

You need to have the Python version available that Blender uses, in my case 3.11. A `shell.nix` is provided for if you have access to nix - you can then just use `nix-shell` to get a Python environment in which you can install dependencies from:

`pip wheel PACKAGE -w ./my_example_extension/wheels`

e.g.

`pip wheel packaging -w ./my_example_extension/wheels`

You'll then have to register all the created wheel files in the `blender_manifest.toml` - an example for the packaging wheel is in there already.

## The Example Add-on

Taken from the Blender wiki, it's the basic "move all objects in the x direction" add-on, with a few things added in:

- There's a property to the operator that allows to set the amount of steps, from 1 to 10. You'll see a menu on the bottom left of your viewport when clicking `Object > Move X by a few steps` which will allow adjusting the steps.
- During the add-on's registration, it outputs the path to the `packaging` dependency (this is just to show that dependencies work and serves no other purpose)
