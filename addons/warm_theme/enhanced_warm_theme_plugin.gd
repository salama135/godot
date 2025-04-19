@tool
extends EditorPlugin

# Debug mode - set to true to print debug information
const DEBUG = true

# Store original colors to restore them when the plugin is disabled
var original_colors = {}
var ui_elements = {}

# Define a warm color palette with many variations
const COLOR_PALETTE = {
    # Base warm colors
    "peach": Color("#F9E0BB"),
    "pink": Color("#F9C5D5"),
    "tan": Color("#F2D8B3"),
    "coral": Color("#FFCAAF"),
    "amber": Color("#FFE4C0"),
    "gold": Color("#F8D7A8"),
    "lavender": Color("#E8D0FF"),
    "sand": Color("#F5CCA0"),
    "cream": Color("#FFF4E3"),
    "offwhite": Color("#FFFAF2"),
    "ivory": Color("#FFF8E7"),
    "palegold": Color("#F6D6A3"),
    
    # Additional warm colors
    "lightsalmon": Color("#FFA07A"),
    "lightcoral": Color("#F08080"),
    "peachpuff": Color("#FFDAB9"),
    "bisque": Color("#FFE4C4"),
    "moccasin": Color("#FFE4B5"),
    "navajowhite": Color("#FFDEAD"),
    "wheat": Color("#F5DEB3"),
    "burlywood": Color("#DEB887"),
    "sandybrown": Color("#F4A460"),
    "rosybrown": Color("#BC8F8F"),
    "goldenrod": Color("#DAA520"),
    "peru": Color("#CD853F"),
    "chocolate": Color("#D2691E"),
    
    # Lighter tints
    "lightpeach": Color("#FCF0DB"),
    "lightpink": Color("#FCE5ED"),
    "lightttan": Color("#F9F0E3"),
    "lightcoral2": Color("#FFE5DF"),
    "lightamber": Color("#FFF4E0"),
    "lightgold": Color("#FCF0D8"),
    "lightlavender": Color("#F4E8FF"),
    "lightsand": Color("#FAE8D0"),
    "lightcream": Color("#FFFAF3"),
}

# Map UI element names to colors
var element_colors = {
    # Dock panels
    "DockSlotLeftUL": COLOR_PALETTE["peach"],
    "DockSlotLeftUR": COLOR_PALETTE["tan"],
    "DockSlotLeftBL": COLOR_PALETTE["pink"],
    "DockSlotLeftBR": COLOR_PALETTE["coral"],
    "DockSlotRightUL": COLOR_PALETTE["amber"],
    "DockSlotRightUR": COLOR_PALETTE["gold"],
    "DockSlotRightBL": COLOR_PALETTE["lavender"],
    "DockSlotRightBR": COLOR_PALETTE["sand"],
    
    # Dock splits
    "DockHSplitLeftL": COLOR_PALETTE["lightpeach"],
    "DockHSplitLeftR": COLOR_PALETTE["lightpink"],
    "DockHSplitMain": COLOR_PALETTE["lightttan"],
    "DockHSplitRight": COLOR_PALETTE["lightcoral2"],
    "DockVSplitCenter": COLOR_PALETTE["lightamber"],
    "DockVSplitLeftL": COLOR_PALETTE["lightgold"],
    "DockVSplitLeftR": COLOR_PALETTE["lightlavender"],
    "DockVSplitRightL": COLOR_PALETTE["lightsand"],
    "DockVSplitRightR": COLOR_PALETTE["lightcream"],
    
    # Main sections
    "Scene": COLOR_PALETTE["peach"],
    "Inspector": COLOR_PALETTE["pink"],
    "FileSystem": COLOR_PALETTE["tan"],
    "Node": COLOR_PALETTE["coral"],
    "History": COLOR_PALETTE["amber"],
    "Import": COLOR_PALETTE["gold"],
    "Debug": COLOR_PALETTE["lavender"],
    
    # Tabs
    "General": COLOR_PALETTE["peach"],
    "Shortcuts": COLOR_PALETTE["tan"],
    "Input Map": COLOR_PALETTE["pink"],
    "Localization": COLOR_PALETTE["coral"],
    "Globals": COLOR_PALETTE["amber"],
    "Plugins": COLOR_PALETTE["gold"],
    "Import Defaults": COLOR_PALETTE["lavender"],
    
    # Editor sections
    "2D": COLOR_PALETTE["lightpeach"],
    "3D": COLOR_PALETTE["lightpink"],
    "Script": COLOR_PALETTE["lightttan"],
    "AssetLib": COLOR_PALETTE["lightcoral2"],
    "Game": COLOR_PALETTE["lightamber"],
    
    # Common UI elements
    "Panel": COLOR_PALETTE["offwhite"],
    "HBoxContainer": COLOR_PALETTE["offwhite"],
    "VBoxContainer": COLOR_PALETTE["offwhite"],
    "Tree": COLOR_PALETTE["offwhite"],
    "ItemList": COLOR_PALETTE["offwhite"],
    "LineEdit": COLOR_PALETTE["ivory"],
    "SpinBox": COLOR_PALETTE["ivory"],
    "OptionButton": COLOR_PALETTE["ivory"],
    "CheckBox": COLOR_PALETTE["ivory"],
    "ColorRect": COLOR_PALETTE["offwhite"],
    "RichTextLabel": COLOR_PALETTE["offwhite"],
    "EditorInspector": COLOR_PALETTE["offwhite"],
    
    # Other specific elements
    "MainScreen": COLOR_PALETTE["offwhite"],
    "Substitute": COLOR_PALETTE["peach"],
    "Post-Process": COLOR_PALETTE["tan"],
    "Stack Trace": COLOR_PALETTE["pink"],
    "Errors": COLOR_PALETTE["coral"],
    "Evaluator": COLOR_PALETTE["amber"],
    "Profiler": COLOR_PALETTE["gold"],
    "Visual Profiler": COLOR_PALETTE["lavender"],
    "Monitors": COLOR_PALETTE["sand"],
    "Video RAM": COLOR_PALETTE["cream"],
    "Misc": COLOR_PALETTE["peach"],
    "Network Profiler": COLOR_PALETTE["tan"],
    "Tab 1": COLOR_PALETTE["pink"],
    "Tab 2": COLOR_PALETTE["coral"],
    "Tab 3": COLOR_PALETTE["amber"],
    "Options": COLOR_PALETTE["gold"],
    "Resources": COLOR_PALETTE["lavender"],
    "Patches": COLOR_PALETTE["sand"],
    "Features": COLOR_PALETTE["cream"],
    "Encryption": COLOR_PALETTE["peach"],
    "Scripts": COLOR_PALETTE["tan"],
    "Translations": COLOR_PALETTE["pink"],
    "Remaps": COLOR_PALETTE["coral"],
    "POT Generation": COLOR_PALETTE["amber"],
    "Autoload": COLOR_PALETTE["gold"],
    "Shader Globals": COLOR_PALETTE["lavender"],
    "Groups": COLOR_PALETTE["sand"],
    "Meshes": COLOR_PALETTE["cream"],
    "Materials": COLOR_PALETTE["peach"],
    "Rendering Options": COLOR_PALETTE["tan"],
    "Pre-render Configurations": COLOR_PALETTE["pink"],
    "Glyphs from the Translations": COLOR_PALETTE["coral"],
    "Glyphs from the Text": COLOR_PALETTE["amber"],
    "Glyphs from the Character Map": COLOR_PALETTE["gold"],
    "Authors": COLOR_PALETTE["lavender"],
    "Donors": COLOR_PALETTE["sand"],
    "License": COLOR_PALETTE["cream"],
    "Third-party Licenses": COLOR_PALETTE["peach"],
    "Signals": COLOR_PALETTE["tan"],
    "Dependencies": COLOR_PALETTE["pink"],
    "Patterns": COLOR_PALETTE["coral"],
    "Terrains": COLOR_PALETTE["amber"],
    "Tiles": COLOR_PALETTE["gold"],
    "Session 1": COLOR_PALETTE["lavender"],
    "Manual Selection": COLOR_PALETTE["sand"],
    "Project": COLOR_PALETTE["cream"],
    "Editor": COLOR_PALETTE["peach"],
    "Help": COLOR_PALETTE["tan"],
    
    # Special elements
    "ZoomLimitMessageLabel": COLOR_PALETTE["lightpink"],
    "EditorHelpBit": COLOR_PALETTE["lightttan"],
    "SceneTreeEditor": COLOR_PALETTE["lightcoral2"],
    "state_machines": COLOR_PALETTE["lightamber"],
    "end_nodes": COLOR_PALETTE["lightgold"],
    "_connection_layer": COLOR_PALETTE["lightlavender"],
    "_v_scroll": COLOR_PALETTE["lightsand"],
    "DirectionalLight3D": COLOR_PALETTE["lightcream"],
    "CenterContainer": COLOR_PALETTE["offwhite"],
    "ColorPickerButton": COLOR_PALETTE["ivory"],
    "EditorSpinSlider": COLOR_PALETTE["ivory"],
    "HSlider": COLOR_PALETTE["ivory"],
    "lne_search": COLOR_PALETTE["ivory"],
    "lne_replace": COLOR_PALETTE["ivory"],
    "lne_prefix": COLOR_PALETTE["ivory"],
    "lne_suffix": COLOR_PALETTE["ivory"],
}

func _enter_tree():
    # Wait a few frames to ensure the editor is fully loaded
    await get_tree().process_frame
    await get_tree().process_frame
    await get_tree().process_frame
    
    if DEBUG:
        print("[Warm Theme] Plugin enabled, searching for UI elements...")
    
    # Find all UI elements
    find_ui_elements()
    
    # Apply warm theme
    apply_warm_theme()

func _exit_tree():
    # Restore original theme
    restore_original_theme()

func find_ui_elements():
    var base = get_editor_interface().get_base_control()
    
    # Find all nodes in the editor
    var all_nodes = _find_all_nodes(base)
    
    if DEBUG:
        print("[Warm Theme] Found " + str(all_nodes.size()) + " nodes in the editor")
    
    # Filter nodes by name
    for node in all_nodes:
        var node_name = node.name
        
        # Check if this node's name is in our element_colors dictionary
        if element_colors.has(node_name):
            if not ui_elements.has(node_name):
                ui_elements[node_name] = []
            ui_elements[node_name].append(node)
            
            if DEBUG:
                print("[Warm Theme] Found UI element: " + node_name)
    
    if DEBUG:
        print("[Warm Theme] Found " + str(ui_elements.size()) + " unique UI elements")

func apply_warm_theme():
    if DEBUG:
        print("[Warm Theme] Applying warm theme...")
    
    # Apply colors to each UI element
    for element_name in ui_elements:
        var color = element_colors[element_name]
        var nodes = ui_elements[element_name]
        
        for node in nodes:
            _apply_color_to_control(node, color, element_name)
    
    if DEBUG:
        print("[Warm Theme] Theme applied successfully")

func restore_original_theme():
    if DEBUG:
        print("[Warm Theme] Restoring original theme...")
    
    # Restore original colors
    for control in original_colors:
        if is_instance_valid(control):
            var stylebox_name = original_colors[control]["stylebox_name"]
            var original_color = original_colors[control]["color"]
            
            if control.has_theme_stylebox(stylebox_name):
                var panel_stylebox = control.get_theme_stylebox(stylebox_name)
                if panel_stylebox is StyleBoxFlat:
                    var new_stylebox = panel_stylebox.duplicate()
                    new_stylebox.bg_color = original_color
                    control.add_theme_stylebox_override(stylebox_name, new_stylebox)
                    
                    if DEBUG:
                        print("[Warm Theme] Restored original color for " + control.name)
            else:
                if DEBUG:
                    print("[Warm Theme] Could not restore original color for " + control.name)
        else:
            if DEBUG:
                print("[Warm Theme] Control is no longer valid, skipping restoration")
    
    if DEBUG:
        print("[Warm Theme] Original theme restored")

# Helper function to apply color to a control
func _apply_color_to_control(control, color, element_name):
    # Try different stylebox names that might be used for the background
    var stylebox_names = ["panel", "normal", "tab_bg", "tabcontent", "panel_fg", "content", "content_panel", "background"]
    
    for stylebox_name in stylebox_names:
        if control.has_theme_stylebox(stylebox_name):
            var panel_stylebox = control.get_theme_stylebox(stylebox_name)
            if panel_stylebox is StyleBoxFlat:
                # Store original color
                if not original_colors.has(control):
                    original_colors[control] = {
                        "stylebox_name": stylebox_name,
                        "color": panel_stylebox.bg_color
                    }
                
                # Apply new color
                var new_stylebox = panel_stylebox.duplicate()
                new_stylebox.bg_color = color
                control.add_theme_stylebox_override(stylebox_name, new_stylebox)
                
                if DEBUG:
                    print("[Warm Theme] Applied color to " + element_name + " (" + control.name + ") using stylebox '" + stylebox_name + "'")
                return true
    
    if DEBUG:
        print("[Warm Theme] Could not find suitable stylebox for " + element_name + " (" + control.name + ")")
    return false

# Helper function to find all nodes in the editor
func _find_all_nodes(node):
    var result = []
    
    result.append(node)
    
    for child in node.get_children():
        result.append_array(_find_all_nodes(child))
    
    return result
