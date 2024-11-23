# Gui2Lua (Ingame)

`Gui2Lua` is a Roblox script that converts GUI elements into Lua code for easy integration into your projects. It allows you to quickly create and customize GUI components, and generate the corresponding Lua code for use in Roblox Studio.

## Features

- Automatically creates and configures Roblox GUI elements (`TextLabel`, `TextBox`, `Frame`, etc.).
- Converts GUI properties into Lua code.
- Supports parent-child relationships for GUI objects.
- Simple API to customize properties of each element.

- Doesn't work UIGradients

## Usage

1. Execute the script
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/Gui2Lua/refs/heads/main/main.lua"))()
```

2. Enter path to ScreenGui Instance
3. Click "Convert"
> The output code will be saved in Gui2lua/[ScreenGuiName].Lua