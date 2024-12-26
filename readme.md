Ce document est également disponible [en français](readme.fr.md)

## What is this about ?

VEAF missions are stored as files in the `src` folder, alongside other files used to configure the scripts and tools.

To build the `.miz` file that DCS will load, it has to be *compiled* by running the `build.cmd` script. This process uses the files stored in `src` and the VEAF toolset to generate the `.miz` file.

Then, the mission can be loaded in DCS to be run or edited (and saved) in DCS mission editor.
**Warning:** once the mission has been saved in the DCS mission editor, it's possible to run it locally for testing, but not to run it on a DCS server (a few things have to be changed).

The edited `.miz` mission file can be transformed back to files in the `src` folder by using the `extract.cmd` file. It will process the first `.miz` file it finds in the mission folder (the same folder where the `extract.cmd` script is stored), with a file name corresponding to the mission configured in this folder.

### Schema

![schema](https://github.com/VEAF/VEAF-mission-directory-template/raw/master/docs/build_cycle.jpg)

## How to build a mission?

### Prerequisites

See [this page](https://veaf.github.io/documentation/environment/) - [ou en français](https://veaf.github.io/documentation/environment/index.fr.html) - for help installing all the prerequisite tools.

### Build the mission

Building the mission from source is easy ; you simply have to run the `build.cmd` script. You don't even need to run it in a `cmd` window, double-clicking it will be ok.

The process will take all the files in the `src` folder, fetch the latest version of the *VEAF Mission Creation Tools* (from GitHub), and compile all of this in a ready-to-use mission for DCS (in a `.miz` file).

This file will be named after the mission (this is configured in the first line of the `build.cmd` script), and placed in the `build` folder.

### Editing a compiled mission

After a mission has been compiled, copy it from the `build` folder to the main mission folder (the folder where `extract.cmd` and `build.cmd` are stored). Then, you can open it in the DCS Mission Editor and edit it (add/remove units, add triggers, change zones, etc.).

Also, you can edit the mission source files in parallel (using a text editor, I recommend Notepad++ or Visual Studio Code); specifically, you can edit :

- the mission configuration file `src/scripts/missionConfig.lua`, to setup the mission parameters ; this is the main file you'll edit.
- the radio presets file `src/radio/radioSettings.lua`, to setup the radio presets pushed to the aircrafts.
- the weather presets in `src/weatherAndTime`

If you edit one of these files, and because they're compiled *into* the mission `.miz` file, you'll have to *rebuild* your mission before you can test your editions in the game.

There's a way to easily test these changes : the first trigger has a LUA predicate, that conditions the scripts loading method. If set to `false`, the scripts are loading statically (i.e. they're loading *from the mission*) ; if set to `true`, the scripts will be loaded dynamically, so each time you restart the mission in DCS (Left-SHIFT + R) you can test whatever change you saved to the files.

![triggers](https://user-images.githubusercontent.com/172286/109670752-bac72180-7b73-11eb-9d20-cadd84bff1a5.jpg)


### Extract an edited version of the mission

Once a mission has been edited and saved in the DCS mission editor, you need to *extract* its content to the `src` folder, in order to reinject it later with the `build` script.

To do this, simply run the `extract.cmd` script. You don't even need to run it in a `cmd` window, double-clicking it will be ok.

This script will take any mission file starting with the mission name (configured in the beginning of the script), in the mission folder (the folder where `extract.cmd` and `build.cmd` are stored, not the `build` folder), extract its content, process them and store them in `src`.

**Note:** this script can (and will) display errors; some of them are normal, don't be afraid:

- Headers error, due to the fact that DCS is not writing `.miz` file in the standard `zip` format

```
WARNINGS:
Headers Error
```

- Cleanup error on a non existing file

```
deleting veafTransportMission.lua
deleting veafUnits.lua
The system cannot find the file specified.
The system cannot find the file specified.
The system cannot find the file specified.
The system cannot find the file specified.
```

### Dynamic script loading
As was mentioned above, the mission framework allows for an easy switch between static and dynamic mission scripts. Static loading must always be used for the finalized version of your mission, while dynamic mode provides a quick and easy way to test and adjust scripts during the development process.

#### Building in dynamic mode
While it is possible to manually change the predicate of the `MISSION START (choose - static or dynamic)` trigger, as explained earlier, another method is to have a custom `build.cmd` that will build the mission in dynamic mode. The extract/build loop then stays the same, with the added possibility to build in dynamic or static mode depending on the build command used.

To do that, create a command file in the mission folder, next to `build.cmd`. You can name it for example `build-dynamic.cmd`.
```
set DYNAMIC_LOAD_SCRIPTS=true
set MISSION_FILE_SUFFIX1=dynamic
call build.cmd
```
- `DYNAMIC_LOAD_SCRIPTS` will tell the command to build the mission in dynamic mode.
- `MISSION_FILE_SUFFIX1` is optional but recommended to be able to identify dynamic missions by their name.

#### Dynamic config loader
In the `src/scripts` folder you will find the following file: `veafDynamicConfig.lua`. This is the only script that the `MISSION START (choose - static or dynamic)` trigger will execute in dynamic mode.

By default, this script will only load and execute the `missionConfig.lua` script. But if your mission logic requires it, you can amend it to load more scripts. These additional scripts can be loaded before `missionConfig.lua` (for general dependencies that will be needed by the subsequent scripts) or after (for mission logic that will need the veaf scripts loaded by `missionConfig.lua`).

All the additional lua scripts will have to be present in the `src/scripts` folder.
Do note that to have these scripts loaded in static mode as well, you will need to modify the `MISSION START (mission config - static)` and add one action for each file to load, in the right order.

For the dynamic loading, only the `scriptsToLoad` table will have to be modified in `veafDynamicConfig.lua`.

Example:
```
local scriptsToLoad =
{
    -- load BEFORE missionConfig.lua
    "Moose.lua",
    "FgTools.lua",
    "FgWeather.lua",    
    "FgCsg2.lua",
    -- missionConfig.lua
    "missionConfig.lua",
    -- load AFTER missionConfig.lua
    "FgMission.lua"
}
```

### Advanced settings

#### Setting the location of the 7zip executable

If your 7zip tool is not in your PATH, you can set its location in the `SEVENZIP` environment variable. It's a string which should point to the `7za` executable (e.g. `c:\tools\7zip\bin\7zip.exe`)

#### Setting the location of the LUA executable

In the same way, you can set its location of the LUA executable in the `LUA` environment variable. It's a string which should point to the `lua` executable (e.g. `c:\tools\lua\bin\lua.exe`)

#### Skip the pauses

If you set the `NOPAUSE` environment variable to "true", then the pauses in the script will not be marked.

#### Build in dynamic mode
To build the mission in dynamic mode, set `DYNAMIC_LOAD_SCRIPTS=true`

## How to use this - graphic version

![schema](https://github.com/VEAF/VEAF-mission-directory-template/raw/master/docs/build_cycle.jpg)

