@tool
extends EditorScript

# This script helps test and adjust colors for specific UI elements
# Run it from the Godot editor to apply colors to specific elements

func _run():
    print("\n=== ELEMENT COLOR TESTER ===")
    
    # Define a warm color palette
    var colors = {
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
    # Try different stylebox names
    var stylebox_names = ["panel", "normal", "tab_bg", "tabcontent", "panel_fg", "content", "content_panel", "background"]
    
    for stylebox_name in stylebox_names:
        if control.has_theme_stylebox(stylebox_name):
            var panel_stylebox = control.get_theme_stylebox(stylebox_name)
            if panel_stylebox is StyleBoxFlat:
                var new_stylebox = panel_stylebox.duplicate()
                new_stylebox.bg_color = color
                control.add_theme_stylebox_override(stylebox_name, new_stylebox)
                print("Applied color to " + control.name + " using stylebox '" + stylebox_name + "'")
                return true
    
    print("Could not find suitable stylebox for " + control.name)
    return false

func _find_nodes_by_name(node, name):
    var result = []
    
    if node.name == name:
        result.append(node)
    
    for child in node.get_children():
        result.append_array(_find_nodes_by_name(child, name))
    
    return result
