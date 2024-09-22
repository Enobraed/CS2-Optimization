@echo off
title CS2 Optimization
mode con:cols=61 lines=10
@echo CS2 Optimization
@echo Description: Optimize CS2 by deleting unnecessary files with the ability to restore them.
@echo Recommendations: use English in CS2
@echo Version: 0.1
@echo Data: 22.09.2024
@echo Developer: Enobraed (https://t.me/Enobraed)
@echo -------------------------------------------------------------
pause
cls
mode con:cols=93 lines=15
setlocal EnableDelayedExpansion

@echo 1). Kill process cs2.exe
taskkill /f /im "cs2.exe" >nul 2>&1
:checkProcess
tasklist | findstr /i "cs2.exe" >nul && timeout /t 1 >nul && goto checkProcess

set "game=%~dp0\game"
set "backup=.backup\game"

@echo 2). Creating backup folders (necessary for mkdir to work as well)
mkdir "%backup%\bin\win64" ^
      "%backup%\core" ^
      "%backup%\csgo\bin\legacy" ^
      "%backup%\csgo\bin\win64" ^
      "%backup%\csgo\cfg" ^
      "%backup%\csgo\maps" ^
      "%backup%\csgo\resource" ^
      "%backup%\csgo_core" ^
      "%backup%\csgo_imported" 2>nul

@echo 3). Deleting temporary files
del "%~dp0\game\bin\win64\*.mdmp" /s /q >nul 2>&1
del "%~dp0\game\csgo\backup_*.txt" /s /q >nul 2>&1
rd "%~dp0\game\csgo\rpt" /s /q >nul 2>&1
rd "%~dp0\game\csgo\save" /s /q >nul 2>&1

@echo 4). Moving SDK Tools
set SDK=!SDK! gfsdk_aftermath_lib.x64.dll ^
                libfbxsdk_2020_3_1.dll ^
                physicsbuilder.dll ^
                propertyeditor.dll ^
                qt5_plugins ^
                Qt5Concurrent.dll ^
                Qt5Core.dll ^
                Qt5Gui.dll ^
                Qt5Widgets.dll ^
                subtools ^
                toolframework2.dll ^
                vconsole2.exe ^
                visbuilder.dll
for %%F in (%SDK%) do (
    move "%game%\bin\win64\%%F" "%backup%\bin\win64" >nul 2>&1
)

@echo 5). Moving SDK for creating maps
set SDK_MAPS=!SDK_MAPS! core\tools ^
                csgo\maps\editor ^
				csgo\maps\templates
for %%F in (%SDK_MAPS%) do (
    move /Y "%game%\%%F" "%backup%\%%F" >nul 2>&1
)

@echo 6). Moving Vulkan
set Vulkan=!Vulkan! bin\win64\rendersystemvulkan.dll ^
                core\shaders_vulkan_000.vpk ^
                core\shaders_vulkan_dir.vpk ^
                csgo\shaders_vulkan_000.vpk ^
                csgo\shaders_vulkan_001.vpk ^
                csgo\shaders_vulkan_dir.vpk ^
                csgo_core\shaders_vulkan_000.vpk ^
                csgo_core\shaders_vulkan_001.vpk ^
                csgo_core\shaders_vulkan_002.vpk ^
                csgo_core\shaders_vulkan_003.vpk ^
                csgo_core\shaders_vulkan_dir.vpk
for %%F in (!Vulkan!) do (
    move /Y "%game%\%%F" "%backup%\%%F" >nul 2>&1
)

@echo 7). Moving lv (Do not use the -lv startup parameter) Micro-friezes may appear when shooting
move "%game%\csgo_lv" "%backup%" >nul 2>&1

@echo 8). Moving menu background
set Maps=!Maps! ar_baggage_vanity.vpk ^
                cs_italy_vanity.vpk ^
                cs_office_vanity.vpk ^
                de_ancient_vanity.vpk ^
                de_anubis_vanity.vpk ^
                de_dust2_vanity.vpk ^
                de_inferno_vanity.vpk ^
                de_mirage_vanity.vpk ^
                de_nuke_vanity.vpk ^
                de_overpass_vanity.vpk ^
                de_vertigo_vanity.vpk ^
                lobby_mapveto.vpk ^
                warehouse_vanity.vpk ^
                workshop_preview_ancient.vpk ^
                workshop_preview_dust2.vpk ^
                workshop_preview_inferno.vpk
for %%F in (%MAPS%) do (
    move /Y "%game%\csgo\maps\%%F" "%backup%\csgo\maps" >nul 2>&1
)

@echo 9). Moving animations and interface effects
move "%game%\csgo\maps\ui" "%backup%\csgo\maps" >nul 2>&1

@echo 10). Moving the graphics window in the settings
move "%game%\csgo\maps\graphics_settings.vpk" "%backup%\csgo\maps" >nul 2>&1

@echo 11). Moving panorama and fonts
set Panorama=!Panorama! csgo\panorama ^
                core\panorama
for %%F in (%Panorama%) do (
    move /Y "%game%\%%F" "%backup%\%%F" >nul 2>&1
)

@echo 12). Moving various junk files
set Trash=!Trash! bin\built_from_cl.txt ^
                bin\content_built_from_cl.txt ^
                bin\win64\rendersystemempty.dll ^
                core\cfg ^
                core\gameinfo.gi ^
                core\gameinfo_branchspecific.gi ^
                core\maps ^
                csgo\bin\legacy\csgo_legacy_app.exe ^
                csgo\cfg\perftest.cfg ^
                csgo\cfg\server.cfg ^
                csgo\cfg\server_default.cfg ^
                csgo\gameinfo_branchspecific.gi ^
                csgo\resource\game-icon.bmp ^
                csgo_imported\gameinfo_branchspecific.gi ^
                csgo_imported\pak01_000.vpk ^
                csgo_imported\pak01_dir.vpk ^
                thirdpartylegalnotices.txt
for %%F in (%Trash%) do (
    move /Y "%game%\%%F" "%backup%\%%F" >nul 2>&1
)

@echo 13). Deleting empty folders
for /f "usebackq delims=" %%d in (`"dir /ad/b/s | sort /R"`) do rd "%%d" 2>nul
endlocal
pause
cls
mode con:cols=86 lines=4

@echo CS2 optimization is complete. Please check the backup folder. If its size is 2.38 GB, then everything was successful. Otherwise, please try restarting the script.
pause
exit