# Enhanced Color Theme for Godot Editor

This plugin adds a distinctive color scheme to all UI elements in the Godot editor, making the interface more visually distinct and less bland. The theme uses a carefully selected color palette based on Blue Grotto, Cinnabar, Nude, and Ebony colors.

## Features

- Applies a distinctive color palette to all UI elements in the Godot editor
- Uses a modern color scheme based on Blue Grotto, Cinnabar, Nude, and Ebony
- Each element gets its own distinct color based on its type and function
- Colors are carefully chosen to create visual hierarchy and improve usability
- Automatically restores the original theme when disabled
- Includes tools for debugging and testing different color combinations

## Color Palette

The plugin uses a distinctive color palette based on four main colors:

### Base Colors

- Blue Grotto (#5A91BB) - A calming blue tone for primary UI elements
- Cinnabar (#EB515E) - A vibrant red for accent and important elements
- Nude (#D3C0B2) - A neutral beige for background and common elements
- Ebony (#0B0909) - A near-black for dark accents and contrast

### Derived Colors

#### Lighter Tints

- Light Blue Grotto (#8CB3D1) - A lighter version of the blue
- Light Cinnabar (#F28A93) - A lighter version of the red
- Light Nude (#E5D9D0) - A lighter version of the nude color
- Light Ebony (#3D3A3A) - A lighter version of the dark color

#### Darker Shades

- Dark Blue Grotto (#3A6A8F) - A darker version of the blue
- Dark Cinnabar (#B83642) - A darker version of the red
- Dark Nude (#A99889) - A darker version of the nude color
- Dark Ebony (#000000) - Pure black

#### Mixed Colors

- Blue-Red Mix (#9D718A) - A purple tone from mixing blue and red
- Blue-Nude Mix (#96A8B7) - A muted blue from mixing blue and nude
- Red-Nude Mix (#DF8888) - A muted red from mixing red and nude

#### Transparent Versions

- Transparent Blue (#5A91BB with 70% opacity)
- Transparent Red (#EB515E with 70% opacity)
- Transparent Nude (#D3C0B2 with 70% opacity)
- Transparent Ebony (#0B0909 with 70% opacity)

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
