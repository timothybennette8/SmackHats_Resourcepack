@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ====== CONFIG (edit these) ======
set /p NAMESPACE=Enter namespace: 
set "RESOURCEPACK_ROOT=C:\Users\timot\Dev\minecraft\SmackHats_resourcepack"
set "DATAPACK_ROOT=C:\Users\timot\Dev\minecraft\SmackHats_datapack"

set "INPUT_DIR=%RESOURCEPACK_ROOT%\assets\%NAMESPACE%\models\item"

REM Datapack functions path MUST be: data\<namespace>\functions\...
set "DATAPACK_OUTPUT_DIR=%DATAPACK_ROOT%\data\hats\function\items\%NAMESPACE%"
set "DATAPACK_FUNCTION_DIR=%DATAPACK_ROOT%\data\hats\function"
set "INIT_FILE=%DATAPACK_FUNCTION_DIR%\init.mcfunction"
set "TICK_FILE=%DATAPACK_FUNCTION_DIR%\tick.mcfunction"

REM Resourcepack items output
set "RESOURCEPACK_OUTPUT_DIR=%RESOURCEPACK_ROOT%\assets\%NAMESPACE%\items"

REM ================================

if not exist "%DATAPACK_OUTPUT_DIR%" mkdir "%DATAPACK_OUTPUT_DIR%"
if not exist "%RESOURCEPACK_OUTPUT_DIR%" mkdir "%RESOURCEPACK_OUTPUT_DIR%"

REM --- Append to init.mcfunction & tick.mcfunction ---
	>>"%INIT_FILE%" echo.
	>>"%INIT_FILE%" echo # !NAMESPACE!
	>>"%TICK_FILE%" echo.
	>>"%TICK_FILE%" echo # !NAMESPACE!

for %%F in ("%INPUT_DIR%\*") do (
  if exist "%%~fF" (
    set "NAME=%%~nF"

	REM --- Append to init.mcfunction ---
	>>"%TICK_FILE%" echo.
	>>"%TICK_FILE%" echo # !NAME!
	>>"%TICK_FILE%" echo scoreboard players enable @a !NAME!
	>>"%TICK_FILE%" echo execute as @a[scores={!NAME!=1..}] run function hats:items/!NAMESPACE!/!NAME!
	>>"%TICK_FILE%" echo execute as @a[scores={!NAME!=1..}] run scoreboard players set @s !NAME! 0

	REM --- Append to tick.mcfunction ---
	>>"%INIT_FILE%" echo scoreboard objectives add !NAME! trigger

	REM --- Generate datapack .mcfunction files ---
    set "DATAPACK_OUTFILE=%DATAPACK_OUTPUT_DIR%\!NAME!.mcfunction"
    >"!DATAPACK_OUTFILE!" echo give @s carved_pumpkin[custom_name=[{"text":"!NAME!","italic":false,"color":"aqua"}],lore=[[{"text":"replace_me","italic":false}]],attribute_modifiers=[{type:armor,amount:5,slot:head,operation:add_value,id:"%NAMESPACE%:!NAME!"}],equippable={slot:head},unbreakable={},item_model="%NAMESPACE%:!NAME!",tooltip_display={hidden_components:[unbreakable]}]

	REM --- Generate resource pack item files from models ---
    set "RESOURCEPACK_OUTFILE=%RESOURCEPACK_OUTPUT_DIR%\!NAME!.json"
    (
      echo {
      echo   "model": {
      echo     "type": "minecraft:model",
      echo     "model": "%NAMESPACE%:item/!NAME!"
      echo   }
      echo }
    ) > "!RESOURCEPACK_OUTFILE!"
  )
)

echo Done.
endlocal