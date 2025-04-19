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
        print("[Color Theme] Plugin enabled, searching for UI elements...")

    # Find all UI elements
    find_ui_elements()

    # Apply color theme
    apply_color_theme()

func _exit_tree():
    # Restore original theme
    restore_original_theme()

func find_ui_elements():
    var base = get_editor_interface().get_base_control()

    # Find all nodes in the editor
    var all_nodes = _find_all_nodes(base)

    if DEBUG:
        print("[Color Theme] Found " + str(all_nodes.size()) + " nodes in the editor")

    # Filter nodes by name
    for node in all_nodes:
        var node_name = node.name

        # Check if this node's name is in our element_colors dictionary
        if element_colors.has(node_name):
            if not ui_elements.has(node_name):
                ui_elements[node_name] = []
            ui_elements[node_name].append(node)

            if DEBUG:
                print("[Color Theme] Found UI element: " + node_name)

    if DEBUG:
        print("[Color Theme] Found " + str(ui_elements.size()) + " unique UI elements")

func apply_color_theme():
    if DEBUG:
        print("[Color Theme] Applying color theme...")

    # Apply colors to each UI element
    for element_name in ui_elements:
        var color = element_colors[element_name]
        var nodes = ui_elements[element_name]

        for node in nodes:
            _apply_color_to_control(node, color, element_name)

    if DEBUG:
        print("[Color Theme] Theme applied successfully")

func restore_original_theme():
    if DEBUG:
        print("[Color Theme] Restoring original theme...")

    # Restore original colors
    for control in original_colors:
        if is_instance_valid(control):
            var type = original_colors[control]["type"]

            match type:
                "stylebox":
                    _restore_stylebox(control)
                "self_modulate":
                    _restore_self_modulate(control)
                "modulate":
                    _restore_modulate(control)
                "custom_draw":
                    _restore_custom_draw(control)
                _:
                    if DEBUG:
                        print("[Color Theme] Unknown restoration type for " + control.name)
        else:
            if DEBUG:
                print("[Color Theme] Control is no longer valid, skipping restoration")

    if DEBUG:
        print("[Color Theme] Original theme restored")

# Restore original stylebox
func _restore_stylebox(control):
    var stylebox_name = original_colors[control]["stylebox_name"]
    var original_color = original_colors[control]["color"]

    # Check if the control supports theme styleboxes
    if not control is Control:
        if DEBUG:
            print("[Color Theme] Could not restore original stylebox for " + control.name + " (not a Control)")
        return

    # Check if the control has this stylebox method
    if not control.has_method("has_theme_stylebox"):
        if DEBUG:
            print("[Color Theme] Could not restore original stylebox for " + control.name + " (no has_theme_stylebox method)")
        return

    if control.has_theme_stylebox(stylebox_name):
        var panel_stylebox = control.get_theme_stylebox(stylebox_name)
        if panel_stylebox is StyleBoxFlat:
            var new_stylebox = panel_stylebox.duplicate()
            new_stylebox.bg_color = original_color
            control.add_theme_stylebox_override(stylebox_name, new_stylebox)

            if DEBUG:
                print("[Color Theme] Restored original stylebox for " + control.name)
    else:
        if DEBUG:
            print("[Color Theme] Could not restore original stylebox for " + control.name)

# Restore original self_modulate
func _restore_self_modulate(control):
    var original_color = original_colors[control]["color"]

    if control is CanvasItem and control.has_method("set_self_modulate"):
        # Check if we can safely access self_modulate
        var has_self_modulate = false
        for property in control.get_property_list():
            if property.name == "self_modulate":
                has_self_modulate = true
                break

        if has_self_modulate:
            control.set_self_modulate(original_color)

            if DEBUG:
                print("[Color Theme] Restored original self_modulate for " + control.name)
            return

    if DEBUG:
        print("[Color Theme] Could not restore original self_modulate for " + control.name)

# Restore original modulate
func _restore_modulate(control):
    var original_color = original_colors[control]["color"]

    if control is CanvasItem and control.has_method("set_modulate"):
        # Check if we can safely access modulate
        var has_modulate = false
        for property in control.get_property_list():
            if property.name == "modulate":
                has_modulate = true
                break

        if has_modulate:
            control.set_modulate(original_color)

            if DEBUG:
                print("[Color Theme] Restored original modulate for " + control.name)
            return

    if DEBUG:
        print("[Color Theme] Could not restore original modulate for " + control.name)

# Restore original draw behavior
func _restore_custom_draw(control):
    # Disconnect our custom draw method
    if control.is_connected("draw", Callable(self, "_custom_draw")):
        control.disconnect("draw", Callable(self, "_custom_draw"))
        control.queue_redraw()

        if DEBUG:
            print("[Color Theme] Removed custom drawing for " + control.name)
    else:
        if DEBUG:
            print("[Color Theme] Could not remove custom drawing for " + control.name)

# Helper function to apply color to a control
func _apply_color_to_control(control, color, element_name):
    # First try using styleboxes (preferred method)
    if _try_apply_stylebox_color(control, color, element_name):
        return true

    # If styleboxes didn't work, try direct background color
    if _try_apply_direct_color(control, color, element_name):
        return true

    # If direct color didn't work, try custom drawing
    if _try_apply_custom_drawing(control, color, element_name):
        return true

    # If all methods failed, report failure
    if DEBUG:
        print("[Color Theme] Could not apply color to " + element_name + " (" + control.name + ") - no suitable method found")
    return false

# Try to apply color using styleboxes
func _try_apply_stylebox_color(control, color, element_name):
    # Check if the control supports theme styleboxes
    if not control is Control:
        return false

    # Try different stylebox names that might be used for the background
    var stylebox_names = ["panel", "normal", "tab_bg", "tabcontent", "panel_fg", "content", "content_panel", "background",
                         "read_only", "focus", "hover", "pressed", "disabled", "selected", "empty", "flat"]

    for stylebox_name in stylebox_names:
        # Check if the control has this stylebox method
        if not control.has_method("has_theme_stylebox"):
            continue

        if control.has_theme_stylebox(stylebox_name):
            var panel_stylebox = control.get_theme_stylebox(stylebox_name)
            if panel_stylebox is StyleBoxFlat:
                # Store original color
                if not original_colors.has(control):
                    original_colors[control] = {
                        "type": "stylebox",
                        "stylebox_name": stylebox_name,
                        "color": panel_stylebox.bg_color
                    }

                # Apply enhanced skeuomorphic styling
                var new_stylebox = panel_stylebox.duplicate()

                # Set base color
                new_stylebox.bg_color = color

                # Add more pronounced rounded corners for a more tactile feel
                new_stylebox.corner_radius_top_left = 6
                new_stylebox.corner_radius_top_right = 6
                new_stylebox.corner_radius_bottom_left = 6
                new_stylebox.corner_radius_bottom_right = 6

                # Add thicker borders for better definition
                new_stylebox.border_width_left = 2
                new_stylebox.border_width_top = 2
                new_stylebox.border_width_right = 2
                new_stylebox.border_width_bottom = 2

                # Create a gradient effect with border colors
                var border_top_color = Color(color.r * 1.1, color.g * 1.1, color.b * 1.1, 1.0).clamp(0, 1)
                var border_bottom_color = Color(color.r * 0.7, color.g * 0.7, color.b * 0.7, 1.0)

                # Apply border colors for a beveled look
                new_stylebox.border_color = border_bottom_color

                # Add stronger shadow for more elevation
                new_stylebox.shadow_color = Color(0, 0, 0, 0.3)
                new_stylebox.shadow_size = 4
                new_stylebox.shadow_offset = Vector2(2, 2)

                # Add content margin for a more padded, tactile feel
                new_stylebox.content_margin_left = 8
                new_stylebox.content_margin_top = 8
                new_stylebox.content_margin_right = 8
                new_stylebox.content_margin_bottom = 8

                control.add_theme_stylebox_override(stylebox_name, new_stylebox)

                if DEBUG:
                    print("[Color Theme] Applied color to " + element_name + " (" + control.name + ") using stylebox '" + stylebox_name + "'")
                return true

    return false

# Try to apply color directly to the control's background
func _try_apply_direct_color(control, color, element_name):
    # Check if the control has self_modulate property
    if control is CanvasItem and control.has_method("set_self_modulate"):
        # Check if we can safely access self_modulate
        var has_self_modulate = false
        for property in control.get_property_list():
            if property.name == "self_modulate":
                has_self_modulate = true
                break

        if has_self_modulate:
            # Store original color
            if not original_colors.has(control):
                original_colors[control] = {
                    "type": "self_modulate",
                    "color": control.self_modulate
                }

            # Apply new color with some transparency to preserve content
            var modulated_color = Color(color.r, color.g, color.b, 0.7)
            control.set_self_modulate(modulated_color)

            if DEBUG:
                print("[Color Theme] Applied color to " + element_name + " (" + control.name + ") using self_modulate")
            return true

    # For Label, RichTextLabel, etc. that have a modulate property
    if control is CanvasItem and control.has_method("set_modulate"):
        # Check if we can safely access modulate
        var has_modulate = false
        for property in control.get_property_list():
            if property.name == "modulate":
                has_modulate = true
                break

        if has_modulate:
            # Store original color
            if not original_colors.has(control):
                original_colors[control] = {
                    "type": "modulate",
                    "color": control.modulate
                }

            # Apply new color with some transparency to preserve content
            var modulated_color = Color(color.r, color.g, color.b, 0.7)
            control.set_modulate(modulated_color)

            if DEBUG:
                print("[Color Theme] Applied color to " + element_name + " (" + control.name + ") using modulate")
            return true

    return false

# Try to apply color using custom drawing
func _try_apply_custom_drawing(control, color, element_name):
    # For controls that support custom drawing
    if control is Control:
        # Store original draw method if not already stored
        if not original_colors.has(control):
            # Check if the control already has a draw handler
            var has_draw_handler = false
            var signal_list = control.get_signal_list()
            for signal_info in signal_list:
                if signal_info.name == "draw":
                    has_draw_handler = true
                    break

            original_colors[control] = {
                "type": "custom_draw",
                "has_draw_handler": has_draw_handler
            }

        # Connect our custom draw method
        if not control.is_connected("draw", Callable(self, "_custom_draw")):
            # Disconnect any existing draw handler to avoid conflicts
            if original_colors[control]["has_draw_handler"]:
                var connections = control.get_signal_connection_list("draw")
                for connection in connections:
                    control.disconnect("draw", connection.callable)

            # Connect our custom draw method
            control.connect("draw", Callable(self, "_custom_draw").bind(control, color))
            control.queue_redraw()

            if DEBUG:
                print("[Color Theme] Applied color to " + element_name + " (" + control.name + ") using custom drawing")
            return true

    return false

# Custom draw method for controls with skeuomorphic effects
func _custom_draw(control, color):
    var size = control.get_size()
    var rect = Rect2(Vector2.ZERO, size)

    # Base color with low opacity to preserve content
    var draw_color = Color(color.r, color.g, color.b, 0.3)

    # Draw main background
    control.draw_rect(rect, draw_color)

    # Draw rounded corners for a more tactile feel
    var corner_radius = 6
    var corner_size = Vector2(corner_radius, corner_radius)

    # Draw border for definition
    var border_width = 2
    var border_color = Color(color.r * 0.7, color.g * 0.7, color.b * 0.7, 0.5)

    # Top border (lighter for bevel effect)
    var top_border = Rect2(Vector2(0, 0), Vector2(size.x, border_width))
    control.draw_rect(top_border, Color(color.r * 1.1, color.g * 1.1, color.b * 1.1, 0.5).clamp(0, 1))

    # Left border (lighter for bevel effect)
    var left_border = Rect2(Vector2(0, 0), Vector2(border_width, size.y))
    control.draw_rect(left_border, Color(color.r * 1.1, color.g * 1.1, color.b * 1.1, 0.5).clamp(0, 1))

    # Bottom border (darker for shadow effect)
    var bottom_border = Rect2(Vector2(0, size.y - border_width), Vector2(size.x, border_width))
    control.draw_rect(bottom_border, border_color)

    # Right border (darker for shadow effect)
    var right_border = Rect2(Vector2(size.x - border_width, 0), Vector2(border_width, size.y))
    control.draw_rect(right_border, border_color)

    # Draw shadow
    var shadow_offset = Vector2(2, 2)
    var shadow_rect = Rect2(shadow_offset, size - shadow_offset)
    control.draw_rect(shadow_rect, Color(0, 0, 0, 0.1))

# Helper function to find all nodes in the editor
func _find_all_nodes(node):
    var result = []

    result.append(node)

    for child in node.get_children():
        result.append_array(_find_all_nodes(child))

    return result
