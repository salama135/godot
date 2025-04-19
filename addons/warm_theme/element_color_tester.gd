@tool
extends EditorScript

# This script helps test and adjust colors for specific UI elements
# Run it from the Godot editor to apply colors to specific elements

func _run():
    print("\n=== ELEMENT COLOR TESTER ===")

    # Define our color palette
    var colors = {
        # Base colors
        "blue": Color("#5A91BB"),       # Blue Grotto
        "red": Color("#EB515E"),        # Cinnabar
        "nude": Color("#D3C0B2"),       # Nude
        "dark": Color("#0B0909"),       # Ebony

        # Lighter tints
        "light_blue": Color("#8CB3D1"),  # Lighter Blue Grotto
        "light_red": Color("#F28A93"),   # Lighter Cinnabar
        "light_nude": Color("#E5D9D0"),  # Lighter Nude
        "light_dark": Color("#3D3A3A"),  # Lighter Ebony

        # Darker shades
        "dark_blue": Color("#3A6A8F"),   # Darker Blue Grotto
        "dark_red": Color("#B83642"),    # Darker Cinnabar
        "dark_nude": Color("#A99889"),   # Darker Nude

        # Mixed colors
        "blue_red": Color("#9D718A"),    # Mix of Blue and Red
        "blue_nude": Color("#96A8B7"),   # Mix of Blue and Nude
        "red_nude": Color("#DF8888"),    # Mix of Red and Nude
    }

    # Create a dialog to select an element and color
    var dialog = ConfirmationDialog.new()
    dialog.title = "Element Color Tester"
    dialog.dialog_text = "Select an element and color to apply:"
    dialog.get_ok_button().text = "Apply"

    var vbox = VBoxContainer.new()
    vbox.custom_minimum_size = Vector2(300, 200)
    dialog.add_child(vbox)

    # Element name input
    var element_label = Label.new()
    element_label.text = "Element Name:"
    vbox.add_child(element_label)

    var element_input = LineEdit.new()
    element_input.placeholder_text = "Enter element name"
    vbox.add_child(element_input)

    # Color selection
    var color_label = Label.new()
    color_label.text = "Color:"
    vbox.add_child(color_label)

    var color_option = OptionButton.new()
    for i in range(colors.keys().size()):
        var color_name = colors.keys()[i]
        color_option.add_item(color_name, i)
    vbox.add_child(color_option)

    # Color preview
    var color_preview = ColorRect.new()
    color_preview.custom_minimum_size = Vector2(300, 30)
    color_preview.color = colors[colors.keys()[0]]
    vbox.add_child(color_preview)

    # Update color preview when selection changes
    color_option.connect("item_selected", func(index):
        var color_name = colors.keys()[index]
        color_preview.color = colors[color_name]
    )

    # Apply button action
    dialog.get_ok_button().connect("pressed", func():
        var element_name = element_input.text
        var color_name = colors.keys()[color_option.selected]
        var color = colors[color_name]

        if element_name.strip_edges() != "":
            _apply_color_to_element(element_name, color)

        dialog.queue_free()
    )

    dialog.get_cancel_button().connect("pressed", func():
        dialog.queue_free()
    )

    get_editor_interface().get_base_control().add_child(dialog)
    dialog.popup_centered()

func _apply_color_to_element(element_name, color):
    print("Applying " + color.to_html() + " to elements named '" + element_name + "'")

    var base = get_editor_interface().get_base_control()
    var elements = _find_nodes_by_name(base, element_name)

    if elements.size() == 0:
        print("No elements found with name '" + element_name + "'")
        return

    print("Found " + str(elements.size()) + " elements with name '" + element_name + "'")

    for element in elements:
        _apply_color_to_control(element, color)

func _apply_color_to_control(control, color):
    # First try using styleboxes (preferred method)
    if _try_apply_stylebox_color(control, color):
        return true

    # If styleboxes didn't work, try direct background color
    if _try_apply_direct_color(control, color):
        return true

    # If direct color didn't work, try custom drawing
    if _try_apply_custom_drawing(control, color):
        return true

    # If all methods failed, report failure
    print("Could not apply color to " + control.name + " - no suitable method found")
    return false

# Try to apply color using styleboxes
func _try_apply_stylebox_color(control, color):
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
                # Apply new color
                var new_stylebox = panel_stylebox.duplicate()
                new_stylebox.bg_color = color
                control.add_theme_stylebox_override(stylebox_name, new_stylebox)

                print("Applied color to " + control.name + " using stylebox '" + stylebox_name + "'")
                return true

    return false

# Try to apply color directly to the control's background
func _try_apply_direct_color(control, color):
    # Check if the control has self_modulate property
    if control is CanvasItem and control.has_method("set_self_modulate"):
        # Check if we can safely access self_modulate
        var has_self_modulate = false
        for property in control.get_property_list():
            if property.name == "self_modulate":
                has_self_modulate = true
                break

        if has_self_modulate:
            # Apply new color with some transparency to preserve content
            var modulated_color = Color(color.r, color.g, color.b, 0.7)
            control.set_self_modulate(modulated_color)

            print("Applied color to " + control.name + " using self_modulate")
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
            # Apply new color with some transparency to preserve content
            var modulated_color = Color(color.r, color.g, color.b, 0.7)
            control.set_modulate(modulated_color)

            print("Applied color to " + control.name + " using modulate")
            return true

    return false

# Try to apply color using custom drawing
func _try_apply_custom_drawing(control, color):
    # For controls that support custom drawing
    if control is Control:
        # Connect our custom draw method
        if not control.is_connected("draw", Callable(self, "_custom_draw")):
            # Disconnect any existing draw handlers to avoid conflicts
            var connections = control.get_signal_connection_list("draw")
            for connection in connections:
                control.disconnect("draw", connection.callable)

            # Connect our custom draw method
            control.connect("draw", Callable(self, "_custom_draw").bind(control, color))
            control.queue_redraw()

            print("Applied color to " + control.name + " using custom drawing")
            return true

    return false

# Custom draw method for controls
func _custom_draw(control, color):
    # Draw a colored rectangle behind the control's content
    var rect = Rect2(Vector2.ZERO, control.get_size())
    var draw_color = Color(color.r, color.g, color.b, 0.3) # Use low opacity to preserve content
    control.draw_rect(rect, draw_color)

func _find_nodes_by_name(node, name):
    var result = []

    if node.name == name:
        result.append(node)

    for child in node.get_children():
        result.append_array(_find_nodes_by_name(child, name))

    return result
