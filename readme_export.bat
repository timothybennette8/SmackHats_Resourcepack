@echo off
setlocal EnableExtensions DisableDelayedExpansion

REM Folder this .bat lives in (ends with \)
set "ROOT=%~dp0"
set "INPUT_DIR=%ROOT%assets"
set "README_FILE=%ROOT%README.md"

REM Store a literal exclamation mark safely
set "BANG=!"

REM Now enable delayed expansion for loop vars
setlocal EnableDelayedExpansion

for /d %%D in ("%INPUT_DIR%\*") do (
    set "PACK=%%~nD"
    set "ITEMS=%%~fD\items"

    if exist "!ITEMS!\" (
        for %%F in ("!ITEMS!\*.*") do (
            if exist "%%~fF" (
                set "NAME=%%~nF"
                >>"%README_FILE%" echo ^| !NAME! ^| /trigger !NAME! ^| !PACK! ^| !BANG![!NAME!](renders/!NAME!.png^)^|
            )
        )
    )
)

endlocal
endlocal