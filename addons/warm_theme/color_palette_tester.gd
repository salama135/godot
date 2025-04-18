@tool
extends EditorScript

# This script helps test different color palettes for the warm theme
# Run it from the Godot editor to apply a different color palette

func _run():
	# Define alternative color palettes
	var palettes = {
		"warm": {
			"scene_dock": Color("#F9E0BB"),       # Light peach
			"inspector_dock": Color("#F9C5D5"),   # Light pink
			"filesystem_dock": Color("#F2D8B3"),  # Light tan
			"node_dock": Color("#FFCAAF"),        # Light coral
			"history_dock": Color("#FFE4C0"),     # Light amber
			"import_dock": Color("#F8D7A8"),      # Light gold
			
			"bottom_panel": Color("#F5CCA0"),     # Warm sand
			"script_editor": Color("#FFF4E3"),    # Cream
			
			"2d_editor": Color("#FFFAF2"),        # Off-white
			"3d_editor": Color("#FFF8E7"),        # Ivory
			
			"toolbar": Color("#F6D6A3"),          # Pale gold
			"playbuttons": Color("#FFD9B7"),      # Peach
		},
		"pastel": {
			"scene_dock": Color("#E0F9BB"),       # Light mint
			"inspector_dock": Color("#C5F9D5"),   # Light aqua
			"filesystem_dock": Color("#D8F2B3"),  # Light lime
			"node_dock": Color("#CAFFAF"),        # Light green
			"history_dock": Color("#E4FFE0"),     # Light sage
			"import_dock": Color("#D7F8A8"),      # Light chartreuse
			
			"bottom_panel": Color("#CAF5A0"),     # Pale green
			"script_editor": Color("#F4FFF3"),    # Mint cream
			
			"2d_editor": Color("#F2FFF2"),        # Pale mint
			"3d_editor": Color("#F7FFF8"),        # Pale sage
			
			"toolbar": Color("#D6F6A3"),          # Pale lime
			"playbuttons": Color("#D9FFB7"),      # Pale green
		},
		"cool": {
			"scene_dock": Color("#BBE0F9"),       # Light blue
			"inspector_dock": Color("#D5C5F9"),   # Light lavender
			"filesystem_dock": Color("#B3D8F2"),  # Light sky blue
			"node_dock": Color("#AFCAFF"),        # Light periwinkle
			"history_dock": Color("#E0E4FF"),     # Light azure
			"import_dock": Color("#A8D7F8"),      # Light steel blue
			
			"bottom_panel": Color("#A0CAF5"),     # Pale blue
			"script_editor": Color("#F3F4FF"),    # Lavender mist
			
			"2d_editor": Color("#F2F2FF"),        # Pale lavender
			"3d_editor": Color("#F7F8FF"),        # Pale azure
			
			"toolbar": Color("#A3D6F6"),          # Pale sky blue
			"playbuttons": Color("#B7D9FF"),      # Pale periwinkle
		},
		"sunset": {
			"scene_dock": Color("#FFCBA4"),       # Peach
			"inspector_dock": Color("#FFB4A2"),   # Salmon
			"filesystem_dock": Color("#FFCF96"),  # Light orange
			"node_dock": Color("#FFABAB"),        # Light coral
			"history_dock": Color("#FFD8BE"),     # Light apricot
			"import_dock": Color("#FFBB98"),      # Light salmon
			
			"bottom_panel": Color("#FFAC81"),     # Light coral
			"script_editor": Color("#FFF6F0"),    # Seashell
			
			"2d_editor": Color("#FFF5F5"),        # Misty rose
			"3d_editor": Color("#FFF9F5"),        # Linen
			
			"toolbar": Color("#FFBD9B"),          # Light salmon
			"playbuttons": Color("#FFA07A"),      # Light salmon
		}
	}
	
	# Ask the user which palette to apply
	var dialog = ConfirmationDialog.new()
	dialog.title = "Choose Color Palette"
	dialog.dialog_text = "Select a color palette to apply:"
	dialog.get_ok_button().text = "Apply"
	
	var vbox = VBoxContainer.new()
	dialog.add_child(vbox)
	
	var option_button = OptionButton.new()
	vbox.add_child(option_button)
	
	var palette_names = palettes.keys()
	for i in range(palette_names.size()):
		option_button.add_item(palette_names[i].capitalize(), i)
	
	dialog.get_ok_button().connect("pressed", func():
		var selected_palette = palette_names[option_button.selected]
		_apply_palette(palettes[selected_palette])
		dialog.queue_free()
	)
	
	dialog.get_cancel_button().connect("pressed", func():
		dialog.queue_free()
	)
	
	get_editor_interface().get_base_control().add_child(dialog)
	dialog.popup_centered(Vector2(300, 100))

func _apply_palette(palette):
	# Find the plugin instance
	var plugin = _find_plugin_instance()
	if plugin:
		# Update the plugin's color palette
		for key in palette:
			plugin.COLORS[key] = palette[key]
		
		# Reapply the theme
		plugin.apply_warm_theme()
		print("Applied new color palette")
	else:
		print("Could not find the Warm Theme plugin instance")

func _find_plugin_instance():
	# Get the EditorPlugin singleton
	var editor_plugin_instance = null
	
	# Try to find our plugin in the editor's plugin list
	for node in get_editor_interface().get_base_control().get_children():
		if node.get_script() and node.get_script().resource_path.ends_with("warm_theme_plugin.gd"):
			editor_plugin_instance = node
			break
	
	return editor_plugin_instance
