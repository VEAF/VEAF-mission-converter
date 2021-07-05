@echo off
set MISSION_NAME=%1
set MISSION_TEMPLATE=%2

IF [%MISSION_NAME%] == [] GOTO NeedMissionName
goto DontNeedMissionName
:NeedMissionName
echo Mission name is needed ! It will be the name of your mission folder and project. It should not contain any space or underscore, and no trailing .miz (it's not a mission file name) !
echo Usage : init.cmd My-Supercool-Mission [mission_template_file.miz]
set /p MISSION_NAME=What's the name of your mission (no space, no underscore, no accents) ? 
IF [%MISSION_NAME%] == [] GOTO NeedMissionName
goto DontNeedMissionName
goto :EndOfFile
:DontNeedMissionName
echo Mission will be named "%MISSION_NAME%"

IF [%MISSION_TEMPLATE%] == [] GOTO DefineDefaultMissionFile
goto DontDefineDefaultMissionFile
:DefineDefaultMissionFile
set MISSION_TEMPLATE=template.miz
:DontDefineDefaultMissionFile
echo Using template "%MISSION_TEMPLATE%"

echo ----------------------------------------
echo LUA_SCRIPTS_DEBUG_PARAMETER can be set to "-debug" or "-trace" (or not set) ; this will be passed to the lua helper scripts (e.g. veafMissionRadioPresetsEditor and veafMissionNormalizer)
echo defaults to not set
IF [%LUA_SCRIPTS_DEBUG_PARAMETER%] == [] GOTO DefineDefaultLUA_SCRIPTS_DEBUG_PARAMETER
goto DontDefineDefaultLUA_SCRIPTS_DEBUG_PARAMETER
:DefineDefaultLUA_SCRIPTS_DEBUG_PARAMETER
set LUA_SCRIPTS_DEBUG_PARAMETER=
:DontDefineDefaultLUA_SCRIPTS_DEBUG_PARAMETER
echo current value is "%LUA_SCRIPTS_DEBUG_PARAMETER%"

echo ----------------------------------------
echo SEVENZIP (a string) points to the 7za executable
echo defaults "7za", so it needs to be in the path
IF ["%SEVENZIP%"] == [""] GOTO DefineDefaultSEVENZIP
goto DontDefineDefaultSEVENZIP
:DefineDefaultSEVENZIP
set SEVENZIP=7za
:DontDefineDefaultSEVENZIP
echo current value is "%SEVENZIP%"

echo ----------------------------------------
echo LUA (a string) points to the lua executable
echo defaults "lua", so it needs to be in the path
IF ["%LUA%"] == [""] GOTO DefineDefaultLUA
goto DontDefineDefaultLUA
:DefineDefaultLUA
set LUA=lua
:DontDefineDefaultLUA
echo current value is "%LUA%"

echo ----------------------------------------
echo DYNAMIC_SCRIPTS_PATH (a string) points to folder where the VEAF-mission-creation-tools are located
echo defaults this folder
IF ["%DYNAMIC_SCRIPTS_PATH%"] == [""] GOTO DefineDefaultDYNAMIC_SCRIPTS_PATH
goto DontDefineDefaultDYNAMIC_SCRIPTS_PATH
:DefineDefaultDYNAMIC_SCRIPTS_PATH
set DYNAMIC_SCRIPTS_PATH=%~dp0node_modules\veaf-mission-creation-tools\
set NPM_UPDATE=true
:DontDefineDefaultDYNAMIC_SCRIPTS_PATH
echo current value is "%DYNAMIC_SCRIPTS_PATH%"

echo ----------------------------------------
echo NOPAUSE if set to "true", will not pause at the end of the script (useful to chain calls to this script)
echo defaults to "false"
IF [%NOPAUSE%] == [] GOTO DefineDefaultNOPAUSE
goto DontDefineDefaultNOPAUSE
:DefineDefaultNOPAUSE
set NOPAUSE=false
:DontDefineDefaultNOPAUSE
echo current value is "%NOPAUSE%"

echo ----------------------------------------
echo DYNAMIC_MISSION_PATH (a string) points to folder where this mission is located
echo defaults this folder
IF ["%DYNAMIC_MISSION_PATH%"] == [""] GOTO DefineDefaultDYNAMIC_MISSION_PATH
goto DontDefineDefaultDYNAMIC_MISSION_PATH
:DefineDefaultDYNAMIC_MISSION_PATH
set DYNAMIC_MISSION_PATH=%~dp0
:DontDefineDefaultDYNAMIC_MISSION_PATH
echo current value is "%DYNAMIC_MISSION_PATH%"

echo.
echo ----------------------------------------
echo Initializing this folder to contain %MISSION_NAME%
echo Using file `%MISSION_TEMPLATE%` as the basis for this mission
echo ----------------------------------------
echo Stop this script now or it will modify this folder !
echo ----------------------------------------
echo.

IF [%NOPAUSE%] == [true] GOTO NoPause1
pause
:NoPause1


echo ----------------------------------------

set MISSION_FILE=.\build\%MISSION_NAME%.zip

echo.
echo Preparing build.cmd
echo.

copy build.cmd-template build.cmd >nul 2>&1
powershell -File replace.ps1 build.cmd "##MISSION_NAME##" %MISSION_NAME% >nul 2>&1

echo.
echo Preparing extract.cmd
echo.

copy extract.cmd-template extract.cmd >nul 2>&1
powershell -File replace.ps1 extract.cmd "##MISSION_NAME##" %MISSION_NAME% >nul 2>&1

echo.
echo Preparing weather.cmd
echo.

copy weather.cmd-template weather.cmd >nul 2>&1
powershell -File replace.ps1 weather.cmd "##MISSION_NAME##" %MISSION_NAME% >nul 2>&1

echo.
echo Preparing package.json
echo.

copy package.json-template package.json >nul 2>&1
powershell -File replace.ps1 package.json "##MISSION_NAME##" %MISSION_NAME% >nul 2>&1

echo.
echo Preparing missionConfig.lua
echo.

copy src\scripts\missionConfig.lua-template src\scripts\missionConfig.lua >nul 2>&1
powershell -File replace.ps1 src\scripts\missionConfig.lua "##MISSION_NAME##" %MISSION_NAME% >nul 2>&1

echo.
echo prepare the folders
rd /s /q .\build >nul 2>&1
mkdir .\build >nul 2>&1

echo.
echo Extracting the template mission

"%SEVENZIP%" x -y %MISSION_TEMPLATE% -o".\build\" >nul 2>&1

IF ["%NPM_UPDATE%"] == [""] GOTO DontNPM_UPDATE
echo Fetching the veaf-mission-creation-tools package
call npm update
goto DoNPM_UPDATE
:DontNPM_UPDATE
echo skipping npm update
:DoNPM_UPDATE

echo.
echo Injecting the triggers

echo on
pushd %DYNAMIC_SCRIPTS_PATH%\src\scripts\veaf
"%LUA%" veafMissionTriggerInjector.lua %DYNAMIC_MISSION_PATH%\build\ %LUA_SCRIPTS_DEBUG_PARAMETER%
popd
echo off

echo.
echo Rebuilding the mission

"%SEVENZIP%" a -r -tzip %MISSION_NAME%.miz .\build\* -mem=AES256 >nul 2>&1
copy .\build\%MISSION_NAME%.miz .\ >nul 2>&1

echo.
echo Cleanup
echo -------------------------------------------------------
echo Stop this script now or it will cleanup this folder !
echo -------------------------------------------------------
echo.

IF [%NOPAUSE%] == [true] GOTO NoPause2
pause
:NoPause2

rd /s /q .\build >nul 2>&1
del build.cmd-template >nul 2>&1
del extract.cmd-template >nul 2>&1
del package.json-template >nul 2>&1
del weather.cmd-template >nul 2>&1
del src\scripts\missionConfig.lua-template >nul 2>&1
del empty-caucasus.miz >nul 2>&1
del empty-persiangulf.miz >nul 2>&1
del empty-syria.miz >nul 2>&1
del template.miz >nul 2>&1
del "docs\initialize a new Mission Folder.*" >nul 2>&1
del readme.md >nul 2>&1
del readme.fr.md >nul 2>&1
ren readme-build.md readme.md >nul 2>&1
powershell -File replace.ps1 readme.md "readme-build" "readme" >nul 2>&1
ren readme-build.fr.md readme.fr.md >nul 2>&1
del readme.html >nul 2>&1
del readme.fr.html >nul 2>&1
ren readme-build.html readme.html >nul 2>&1
powershell -File replace.ps1 readme.html "readme-build" "readme" >nul 2>&1
ren readme-build.fr.html readme.fr.html >nul 2>&1

echo.
echo ----------------------------------------
echo Built %MISSION_NAME%.miz
echo ----------------------------------------
echo Please open this mission in the mission editor, ensure that there is at least one unit of any kind on the map for each coalition, add a Game Master slot, save it and then run `extract.cmd`
echo ----------------------------------------
echo.

IF [%NOPAUSE%] == [true] GOTO EndOfFile
pause
:EndOfFile
del init.cmd  >nul 2>&1
