Ce document est également disponible [en français](readme.fr.md)

## How to transform an existing mission?

### Prerequisites

#### Manual installation

You need a few things set up on your PC for these scripts to function.

- LUA : you need a working LUA interpreter, in your PATH, ready to be called with the `lua` command
- 7zip : you need 7zip, or another zip tool, in your PATH, ready to be called with the `7zip` command
- Powershell : you need Powershell, and you need it to be configured to allow script execution (read [this article](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.1)) ; basically you need to run this command in an elevated (admin) Powershell prompt : `Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine`
- npm : you need the NPM package manager from NodeJS to get the VEAF mission creation tools ; see [here](https://www.npmjs.com/get-npm)

#### Using Chocolatey

The required tools can easily be installed using *Chocolatey* (see [here](https://chocolatey.org/)).

**WARNING** : do not do both *manual installation* and *Chocolatey installation*

To install Chocolatey, use this command  in an elevated (admin) Powershell prompt : `Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))`

After *Chocolatey* is installed, use these simple commands in a elevated (admin) command prompt to install the required tools :

- LUA : `choco install -y lua`
- 7zip : `choco install -y 7zip.commandline`
- npm : `choco install -y nodejs`

You'll still need to configure Powershell for script execution (read [this article](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.1)) ; basically you need to run this command in an elevated (admin) Powershell prompt : `Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine`

### Create a working directory and install this toolset

Create a folder somewhere on your disk, and name it with the name of your mission. This will be referred as the *working folder*.

For example, I use `D:\dev\_VEAF\VEAF-OpenTraining-Caucasus` for the Caucasus Opentraining mission.

**WARNING** : do not use spaces or special characters in this folder's path. E.g. no `Program files` or `VEAF Missions` but `VEAF_Missions` is OK.

Download this repository on GitHub and unpack all the files in your working folder.

![schema](https://github.com/VEAF/VEAF-mission-directory-template/raw/master/docs/download_repository.jpg)

It should look like this :

![schema](https://github.com/VEAF/VEAF-mission-directory-template/raw/master/docs/working_folder.jpg)

### Choose a starting mission

You must start with a DCS mission file as the basis of your VEAF scripted mission.

We provided a blank canvas for Caucasus (`empty-caucasus.miz`), Syria (`empty-syria.miz`) and Persian Gulf (`empty-persiangulf.miz`)

Copy the mission of your choice in the root of this folder, and name it `template.miz`.

### Run the init.cmd script

Open the working folder in Windows Explorer (the file manager) and double-click on `init.cmd`

It'll ask for a mission name. This is the name of the mission you want to build (no space, no underscore, please), e.g. `VEAF-test-mission`.

The name of the mission will be the name of your project. It should also be the same name as your working folder (not mandatory, but recommended).

It should not contain any space or underscore, and no trailing .miz (it's not a DCS mission file name) !

#### Example

Let's say I want to initialize a new mission called "My cool and shiny mission - Caucasus".

I'll start with replacing spaces with dashes : "My-cool-and-shiny-mission-Caucasus". I'll extract a fresh copy of the `VEAF-mission-directory-template` GitHub repository into a new folder called `My-cool-and-shiny-mission-Caucasus` (we'll refer to this as "mission folder").

As I want to create a mission in Caucasus, and I have no existing mission, I'll rename the `empty-caucasus.miz` to `template.miz` in my mission folder.

Then I'll open my folder in the Windows Explorer, and double-click on `init.cmd`.

At the `What's the name of your mission (no space, no underscore, no accents) ?` prompt, I'll type the name of my mission : `My-cool-and-shiny-mission-Caucasus`.

The script will take `template.miz` (which is in fact `empty-caucasus.miz`, which I renamed) as its basis, and prepare the mission folder with everything needed to compile the mission (create the `.miz` file).

### Editing the mission and running the first extract

The script will run, and you should check for errors in its output.

At the very end, it'll pause and remind you that you should open the newly created mission file in the DCS Mission Editor, ensure that there is at least one unit of any kind on the map for each side (blue **and** red), add a Game Master slot, and save it.

#### Edit and save for the first time in DCS

So, let's simply do that. Start by opening the newly created mission in DCS Mission Editor.

On the main DCS Editor toolbar : 

![schema](https://github.com/VEAF/VEAF-mission-directory-template/raw/master/docs/dcs_toolbar.jpg)

Click on the "game slots" button (1), add at least a blue Game Master

![schema](https://github.com/VEAF/VEAF-mission-directory-template/raw/master/docs/add_game_master.jpg)

Click on the "add ground unit" button (2), add at least a ground unit for each side (blue **and** red)

![schema](https://github.com/VEAF/VEAF-mission-directory-template/raw/master/docs/add_unit.jpg)

Save the mission (3)

#### Extract the mission

The mission is now ready, in a DCS mission file (ending with `.miz`).

We'll need to run the `extract.cmd` script to safely store the content of the mission file into the `src` folder of our working directory.

To do that, simply double-click the `extract.cmd` script in the Windows Explorer, and wait until the end. The script will pause when it's done, so you can look at its output and eventually close the window.

### Next steps

Now that you have a working directory with everything needed to build and maintain a VEAF mission, you should read [this document](.\readme-build.md) to understand the build -> edit -> extract cycle.

### Advanced settings

You can also run the scripts with parameters from the command line.

In a command shell, ensure that you're in the mission working directory (this folder)
simply type `init.cmd`, followed with a space and the name of the mission you want to build (no space, no underscore, please).

E.g. `init.cmd VEAF-test-mission`.

#### Selecting a specific template mission file

By default, the script looks for a `template.miz` file and uses it as the basis for the new mission.

It's possible to specifiy a specific file as the template ; for example : `init.cmd My-cool-and-shiny-mission-Caucasus empty-caucasus.miz`

#### Setting the logging level of the trigger injector

By setting a value to the `LUA_SCRIPTS_DEBUG_PARAMETER` environment variable, it is possible to tune the logging level of the trigger injector LUA script.

Possible values are :

- `-debug` : debug level, additional information
- `-trace` : trace level, everything is written

This is useful to understand why a specific run does not work

#### Setting the location of the 7zip executable

If your 7zip tool is not in your PATH, you can set its location in the `SEVENZIP` environment variable. It's a string which should point to the `7za` executable (e.g. `c:\tools\7zip\bin\7zip.exe`)

#### Setting the location of the LUA executable

In the same way, you can set its location of the LUA executable in the `LUA` environment variable. It's a string which should point to the `lua` executable (e.g. `c:\tools\lua\bin\lua.exe`)

#### Skip the pauses

If you set the `NOPAUSE` environment variable to "true", then the pauses in the script will not be marked.

## How to use this - graphic version

### Initialize a new Mission Folder with this tool

![schema](https://github.com/VEAF/VEAF-mission-directory-template/raw/master/docs/initialize.jpg)

## How to build a mission

Please see [this document](readme-build.md).