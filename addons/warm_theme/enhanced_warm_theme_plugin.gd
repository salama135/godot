@tool
extends EditorPlugin

# Debug mode - set to true to print debug information
const DEBUG = true

# Store original colors to restore them when the plugin is disabled
var original_colors = {}
var ui_elements = {}

# Define a color palette based on the specified colors
const COLOR_PALETTE = {
    # Base colors
    "blue": Color("#5A91BB"),       # Blue Grotto
    "red": Color("#EB515E"),        # Cinnabar
    "nude": Color("#D3C0B2"),       # Nude
    "dark": Color("#0B0909"),       # Ebony

    # Lighter tints of the base colors
    "light_blue": Color("#8CB3D1"),  # Lighter Blue Grotto
    "light_red": Color("#F28A93"),   # Lighter Cinnabar
    "light_nude": Color("#E5D9D0"),  # Lighter Nude
    "light_dark": Color("#3D3A3A"),  # Lighter Ebony

    # Darker shades of the base colors
    "dark_blue": Color("#3A6A8F"),   # Darker Blue Grotto
    "dark_red": Color("#B83642"),    # Darker Cinnabar
    "dark_nude": Color("#A99889"),   # Darker Nude
    "dark_dark": Color("#000000"),   # Darker Ebony

    # Mixed colors
    "blue_red": Color("#9D718A"),    # Mix of Blue and Red
    "blue_nude": Color("#96A8B7"),   # Mix of Blue and Nude
    "red_nude": Color("#DF8888"),    # Mix of Red and Nude

    # Transparent versions for subtle effects
    "trans_blue": Color("#5A91BB", 0.7),
    "trans_red": Color("#EB515E", 0.7),
    "trans_nude": Color("#D3C0B2", 0.7),
    "trans_dark": Color("#0B0909", 0.7),
}

# Map UI element names to colors
var element_colors = {
    # Dock panels
    "DockSlotLeftUL": COLOR_PALETTE["blue"],
    "DockSlotLeftUR": COLOR_PALETTE["light_blue"],
    "DockSlotLeftBL": COLOR_PALETTE["dark_blue"],
    "DockSlotLeftBR": COLOR_PALETTE["blue_nude"],
    "DockSlotRightUL": COLOR_PALETTE["red"],
    "DockSlotRightUR": COLOR_PALETTE["light_red"],
    "DockSlotRightBL": COLOR_PALETTE["dark_red"],
    "DockSlotRightBR": COLOR_PALETTE["red_nude"],

    # Dock splits
    "DockHSplitLeftL": COLOR_PALETTE["trans_blue"],
    "DockHSplitLeftR": COLOR_PALETTE["trans_blue"],
    "DockHSplitMain": COLOR_PALETTE["trans_dark"],
    "DockHSplitRight": COLOR_PALETTE["trans_red"],
    "DockVSplitCenter": COLOR_PALETTE["trans_dark"],
    "DockVSplitLeftL": COLOR_PALETTE["trans_blue"],
    "DockVSplitLeftR": COLOR_PALETTE["trans_blue"],
    "DockVSplitRightL": COLOR_PALETTE["trans_red"],
    "DockVSplitRightR": COLOR_PALETTE["trans_red"],

    # Main sections
    "Scene": COLOR_PALETTE["blue"],
    "Inspector": COLOR_PALETTE["red"],
    "FileSystem": COLOR_PALETTE["blue"],
    "Node": COLOR_PALETTE["blue_nude"],
    "History": COLOR_PALETTE["nude"],
    "Import": COLOR_PALETTE["light_nude"],
    "Debug": COLOR_PALETTE["red"],

    # Tabs
    "General": COLOR_PALETTE["blue"],
    "Shortcuts": COLOR_PALETTE["light_blue"],
    "Input Map": COLOR_PALETTE["blue_nude"],
    "Localization": COLOR_PALETTE["nude"],
    "Globals": COLOR_PALETTE["light_nude"],
    "Plugins": COLOR_PALETTE["red"],
    "Import Defaults": COLOR_PALETTE["light_red"],

    # Editor sections
    "2D": COLOR_PALETTE["light_blue"],
    "3D": COLOR_PALETTE["light_red"],
    "Script": COLOR_PALETTE["light_nude"],
    "AssetLib": COLOR_PALETTE["blue_nude"],
    "Game": COLOR_PALETTE["light_dark"],

    # Common UI elements
    "Panel": COLOR_PALETTE["nude"],
    "HBoxContainer": COLOR_PALETTE["nude"],
    "VBoxContainer": COLOR_PALETTE["nude"],
    "Tree": COLOR_PALETTE["nude"],
    "ItemList": COLOR_PALETTE["nude"],
    "LineEdit": COLOR_PALETTE["light_nude"],
    "SpinBox": COLOR_PALETTE["light_nude"],
    "OptionButton": COLOR_PALETTE["light_nude"],
    "CheckBox": COLOR_PALETTE["light_nude"],
    "ColorRect": COLOR_PALETTE["nude"],
    "RichTextLabel": COLOR_PALETTE["nude"],
    "EditorInspector": COLOR_PALETTE["nude"],

    # Other specific elements
    "MainScreen": COLOR_PALETTE["nude"],
    "Substitute": COLOR_PALETTE["blue"],
    "Post-Process": COLOR_PALETTE["light_blue"],
    "Stack Trace": COLOR_PALETTE["red"],
    "Errors": COLOR_PALETTE["red"],
    "Evaluator": COLOR_PALETTE["light_red"],
    "Profiler": COLOR_PALETTE["blue_red"],
    "Visual Profiler": COLOR_PALETTE["blue_red"],
    "Monitors": COLOR_PALETTE["blue_nude"],
    "Video RAM": COLOR_PALETTE["blue_nude"],
    "Misc": COLOR_PALETTE["nude"],
    "Network Profiler": COLOR_PALETTE["blue_red"],
    "Tab 1": COLOR_PALETTE["blue"],
    "Tab 2": COLOR_PALETTE["red"],
    "Tab 3": COLOR_PALETTE["nude"],
    "Options": COLOR_PALETTE["light_nude"],
    "Resources": COLOR_PALETTE["blue_nude"],
    "Patches": COLOR_PALETTE["blue_nude"],
    "Features": COLOR_PALETTE["light_blue"],
    "Encryption": COLOR_PALETTE["red"],
    "Scripts": COLOR_PALETTE["blue"],
    "Translations": COLOR_PALETTE["blue_nude"],
    "Remaps": COLOR_PALETTE["light_blue"],
    "POT Generation": COLOR_PALETTE["light_nude"],
    "Autoload": COLOR_PALETTE["blue"],
    "Shader Globals": COLOR_PALETTE["blue_red"],
    "Groups": COLOR_PALETTE["blue_nude"],
    "Meshes": COLOR_PALETTE["light_blue"],
    "Materials": COLOR_PALETTE["blue"],
    "Rendering Options": COLOR_PALETTE["blue_nude"],
    "Pre-render Configurations": COLOR_PALETTE["light_blue"],
    "Glyphs from the Translations": COLOR_PALETTE["blue_nude"],
    "Glyphs from the Text": COLOR_PALETTE["light_nude"],
    "Glyphs from the Character Map": COLOR_PALETTE["light_blue"],
    "Authors": COLOR_PALETTE["red"],
    "Donors": COLOR_PALETTE["light_red"],
    "License": COLOR_PALETTE["nude"],
    "Third-party Licenses": COLOR_PALETTE["light_nude"],
    "Signals": COLOR_PALETTE["blue"],
    "Dependencies": COLOR_PALETTE["blue_nude"],
    "Patterns": COLOR_PALETTE["light_blue"],
    "Terrains": COLOR_PALETTE["blue"],
    "Tiles": COLOR_PALETTE["light_blue"],
    "Session 1": COLOR_PALETTE["red"],
    "Manual Selection": COLOR_PALETTE["blue_nude"],
    "Project": COLOR_PALETTE["nude"],
    "Editor": COLOR_PALETTE["blue"],
    "Help": COLOR_PALETTE["light_blue"],

    # Special elements
    "ZoomLimitMessageLabel": COLOR_PALETTE["light_red"],
    "EditorHelpBit": COLOR_PALETTE["light_nude"],
    "SceneTreeEditor": COLOR_PALETTE["blue"],
    "state_machines": COLOR_PALETTE["light_blue"],
    "end_nodes": COLOR_PALETTE["blue_nude"],
    "_connection_layer": COLOR_PALETTE["trans_blue"],
    "_v_scroll": COLOR_PALETTE["trans_nude"],
    "DirectionalLight3D": COLOR_PALETTE["light_nude"],
    "CenterContainer": COLOR_PALETTE["nude"],
    "ColorPickerButton": COLOR_PALETTE["light_nude"],
    "EditorSpinSlider": COLOR_PALETTE["light_nude"],
    "HSlider": COLOR_PALETTE["light_nude"],
    "lne_search": COLOR_PALETTE["light_nude"],
    "lne_replace": COLOR_PALETTE["light_nude"],
    "lne_prefix": COLOR_PALETTE["light_nude"],
    "lne_suffix": COLOR_PALETTE["light_nude"],
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
