# Warm Theme for Godot Editor

This plugin adds warm color variations to different dock panels and UI elements in the Godot editor, making the interface more visually distinct and less bland.

## Features

- Applies a warm color palette to different parts of the Godot editor
- Each dock panel gets its own distinct color
- Colors are carefully chosen to be easy on the eyes
- Automatically restores the original theme when disabled
- Includes tools for debugging and testing different color palettes

## Color Palette

The plugin uses the following warm color palette:

- Scene Dock: Light peach (#F9E0BB)
- Inspector Dock: Light pink (#F9C5D5)
- FileSystem Dock: Light tan (#F2D8B3)
- Node Dock: Light coral (#FFCAAF)
- History Dock: Light amber (#FFE4C0)
- Import Dock: Light gold (#F8D7A8)
- Bottom Panel: Warm sand (#F5CCA0)
- Script Editor: Cream (#FFF4E3)
- 2D Editor: Off-white (#FFFAF2)
- 3D Editor: Ivory (#FFF8E7)
- Toolbar: Pale gold (#F6D6A3)
- Play Buttons: Peach (#FFD9B7)

## Installation

1. Copy the `addons/warm_theme` folder to your project's `addons` folder
2. Go to Project > Project Settings > Plugins
3. Enable the "Warm Theme Editor" plugin

## Customization

You can customize the colors by editing the `COLORS` dictionary in the `warm_theme_plugin.gd` file.

## Debugging and Testing

The plugin includes several tools to help with debugging and testing:

### Debug Mode

You can enable debug mode by setting `DEBUG = true` in the `warm_theme_plugin.gd` file. This will print detailed information about what the plugin is doing.

### UI Structure Debugger

The plugin includes a script to help debug the editor's UI structure. To use it:

1. Open your project in Godot
2. Go to the Script tab
3. Click on "File" > "Open..." and select the `addons/warm_theme/debug_ui.gd` file
4. Click the "Run" button (or press Ctrl+Shift+X)

This will print information about the editor's UI elements to the console, which can help you identify the correct node names and styleboxes to target.

### Color Palette Tester

The plugin includes a script to help test different color palettes. To use it:

1. Open your project in Godot
2. Go to the Script tab
3. Click on "File" > "Open..." and select the `addons/warm_theme/color_palette_tester.gd` file
4. Click the "Run" button (or press Ctrl+Shift+X)

This will open a dialog allowing you to choose from several predefined color palettes to apply to the editor.

## License

MIT License
