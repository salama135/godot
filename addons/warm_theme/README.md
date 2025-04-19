# Enhanced Warm Theme for Godot Editor

This plugin adds warm color variations to all UI elements in the Godot editor, making the interface more visually distinct and less bland.

## Features

- Applies a warm color palette to all UI elements in the Godot editor
- Each element gets its own distinct color based on its type and function
- Colors are carefully chosen to be easy on the eyes and create a cohesive look
- Automatically restores the original theme when disabled
- Includes tools for debugging and testing different color palettes

## Color Palette

The plugin uses an extensive warm color palette with many variations:

### Base Colors

- Peach (#F9E0BB)
- Pink (#F9C5D5)
- Tan (#F2D8B3)
- Coral (#FFCAAF)
- Amber (#FFE4C0)
- Gold (#F8D7A8)
- Lavender (#E8D0FF)
- Sand (#F5CCA0)
- Cream (#FFF4E3)
- Off-white (#FFFAF2)
- Ivory (#FFF8E7)
- Pale gold (#F6D6A3)

### Additional Colors

- Light salmon (#FFA07A)
- Light coral (#F08080)
- Peach puff (#FFDAB9)
- Bisque (#FFE4C4)
- Moccasin (#FFE4B5)
- Navajo white (#FFDEAD)
- Wheat (#F5DEB3)
- Burlywood (#DEB887)
- Sandy brown (#F4A460)
- Rosy brown (#BC8F8F)
- Goldenrod (#DAA520)
- Peru (#CD853F)
- Chocolate (#D2691E)

### Lighter Tints

- Light peach (#FCF0DB)
- Light pink (#FCE5ED)
- Light tan (#F9F0E3)
- Light coral (#FFE5DF)
- Light amber (#FFF4E0)
- Light gold (#FCF0D8)
- Light lavender (#F4E8FF)
- Light sand (#FAE8D0)
- Light cream (#FFFAF3)

## Installation

1. Copy the `addons/warm_theme` folder to your project's `addons` folder
2. Go to Project > Project Settings > Plugins
3. Enable the "Enhanced Warm Theme Editor" plugin

## Customization

You can customize the colors by editing the `element_colors` dictionary in the `enhanced_warm_theme_plugin.gd` file.

## Included Tools

The plugin includes several tools to help with debugging and testing:

### Debug Mode

You can enable debug mode by setting `DEBUG = true` in the `enhanced_warm_theme_plugin.gd` file. This will print detailed information about what the plugin is doing.

### UI Structure Debugger

The plugin includes a script to help debug the editor's UI structure. To use it:

1. Open your project in Godot
2. Go to the Script tab
3. Click on "File" > "Open..." and select the `addons/warm_theme/debug_ui.gd` file
4. Click the "Run" button (or press Ctrl+Shift+X)

This will print information about the editor's UI elements to the console, which can help you identify the correct node names and styleboxes to target.

### Dock Inspector

The plugin includes a script to help identify the dock structure in the current Godot version. To use it:

1. Open your project in Godot
2. Go to the Script tab
3. Click on "File" > "Open..." and select the `addons/warm_theme/dock_inspector.gd` file
4. Click the "Run" button (or press Ctrl+Shift+X)

This will print detailed information about the docks in the editor, including their names, positions, and tab titles.

### Element Color Tester

The plugin includes a script to help test and adjust colors for specific UI elements. To use it:

1. Open your project in Godot
2. Go to the Script tab
3. Click on "File" > "Open..." and select the `addons/warm_theme/element_color_tester.gd` file
4. Click the "Run" button (or press Ctrl+Shift+X)

This will open a dialog allowing you to enter the name of a UI element and choose a color to apply to it.

### Color Palette Tester

The plugin includes a script to help test different color palettes. To use it:

1. Open your project in Godot
2. Go to the Script tab
3. Click on "File" > "Open..." and select the `addons/warm_theme/color_palette_tester.gd` file
4. Click the "Run" button (or press Ctrl+Shift+X)

This will open a dialog allowing you to choose from several predefined color palettes to apply to the editor.

## License

MIT License
