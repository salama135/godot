@tool
extends EditorScript

# This script generates a preview image of the warm theme colors
# Run it from the Godot editor to see the color palette

func _run():
	var colors = {
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
	}
	
	var window = Window.new()
	window.title = "Warm Theme Preview"
	window.size = Vector2(600, 400)
	window.position = Vector2(100, 100)
	
	var grid = GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 10)
	grid.add_theme_constant_override("v_separation", 10)
	grid.anchors_preset = Control.PRESET_FULL_RECT
	grid.offset_left = 20
	grid.offset_top = 20
	grid.offset_right = -20
	grid.offset_bottom = -20
	
	window.add_child(grid)
	
	for color_name in colors:
		var panel = Panel.new()
		var stylebox = StyleBoxFlat.new()
		stylebox.bg_color = colors[color_name]
		stylebox.corner_radius_top_left = 8
		stylebox.corner_radius_top_right = 8
		stylebox.corner_radius_bottom_left = 8
		stylebox.corner_radius_bottom_right = 8
		panel.add_theme_stylebox_override("panel", stylebox)
		panel.custom_minimum_size = Vector2(180, 80)
		
		var label = Label.new()
		label.text = color_name + "\n" + colors[color_name].to_html()
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.anchors_preset = Control.PRESET_FULL_RECT
		
		panel.add_child(label)
		grid.add_child(panel)
	
	get_editor_interface().get_base_control().add_child(window)
	window.show()
	
	print("Warm Theme Preview window created. Close it when you're done viewing.")
