@tool
extends EditorPlugin

# Warm color palette
const COLORS = {
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

# Debug mode - set to true to print debug information
const DEBUG = true

# Store original colors to restore them when the plugin is disabled
var original_colors = {}
var dock_containers = []
var bottom_panel = null
var main_vbox = null
var main_container = null
var toolbar = null
var play_buttons = null
var editor_tabs = null

func _enter_tree():
	# Get references to UI elements
	# Wait a few frames to ensure the editor is fully loaded
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame

	if DEBUG:
		print("[Warm Theme] Plugin enabled, searching for UI elements...")

	# Find all dock containers
	dock_containers = _find_dock_containers()
	bottom_panel = _find_bottom_panel()
	main_container = _find_main_container()
	toolbar = _find_toolbar()
	play_buttons = _find_play_buttons()
	editor_tabs = _find_editor_tabs()

	if DEBUG:
		print("[Warm Theme] Found " + str(dock_containers.size()) + " dock containers")
		print("[Warm Theme] Bottom panel found: " + str(bottom_panel != null))
		print("[Warm Theme] Main container found: " + str(main_container != null))
		print("[Warm Theme] Toolbar found: " + str(toolbar != null))
		print("[Warm Theme] Play buttons found: " + str(play_buttons != null))
		print("[Warm Theme] Editor tabs found: " + str(editor_tabs != null))

	# Apply warm theme
	apply_warm_theme()

func _exit_tree():
	# Restore original colors
	restore_original_theme()

func apply_warm_theme():
	if DEBUG:
		print("[Warm Theme] Applying warm theme...")

	# Apply colors to dock panels
	for i in range(dock_containers.size()):
		var container = dock_containers[i]
		if container and container is TabContainer:
			# Try different stylebox names that might be used for the background
			var stylebox_names = ["panel", "tab_bg", "tabcontent", "panel_fg", "content"]
			var panel_stylebox = null

			# Find the first valid stylebox
			for stylebox_name in stylebox_names:
				# Use a safe approach instead of try/except
				if container.has_theme_stylebox(stylebox_name):
					var sb = container.get_theme_stylebox(stylebox_name)
					if sb is StyleBoxFlat:
						panel_stylebox = sb
						break

			if panel_stylebox is StyleBoxFlat:
				# Store original color
				if not original_colors.has(container):
					original_colors[container] = panel_stylebox.bg_color

				# Apply new color based on container index
				var color_key = ""
				match i:
					0, 1: color_key = "scene_dock"
					2, 3: color_key = "filesystem_dock"
					4, 5: color_key = "inspector_dock"
					6: color_key = "node_dock"
					7: color_key = "history_dock"

				if color_key != "":
					var new_stylebox = panel_stylebox.duplicate()
					new_stylebox.bg_color = COLORS[color_key]
					container.add_theme_stylebox_override("panel", new_stylebox)

					if DEBUG:
						print("[Warm Theme] Applied " + color_key + " to dock container " + str(i))
			else:
				if DEBUG:
					print("[Warm Theme] Could not find suitable stylebox for dock container " + str(i))

	# Apply color to bottom panel
	if bottom_panel:
		_apply_color_to_control(bottom_panel, "bottom_panel", ["panel", "content_panel", "background"])

	# Apply color to main container (2D/3D editor)
	if main_container:
		_apply_color_to_control(main_container, "2d_editor", ["panel", "content", "background"])

	# Apply color to toolbar
	if toolbar:
		_apply_color_to_control(toolbar, "toolbar", ["panel", "background"])

	# Apply color to play buttons
	if play_buttons:
		_apply_color_to_control(play_buttons, "playbuttons", ["panel", "background"])

	# Apply color to editor tabs
	if editor_tabs:
		_apply_color_to_control(editor_tabs, "script_editor", ["panel", "tab_bg", "tabcontent"])

	if DEBUG:
		print("[Warm Theme] Theme applied successfully")

# Helper function to apply color to a control
func _apply_color_to_control(control, color_key, stylebox_names):
	var panel_stylebox = null
	var used_stylebox_name = ""

	# Find the first valid stylebox
	for stylebox_name in stylebox_names:
		# Use a safe approach instead of try/except
		if control.has_theme_stylebox(stylebox_name):
			var sb = control.get_theme_stylebox(stylebox_name)
			if sb is StyleBoxFlat:
				panel_stylebox = sb
				used_stylebox_name = stylebox_name
				break

	if panel_stylebox is StyleBoxFlat:
		# Store original color
		if not original_colors.has(control):
			original_colors[control] = panel_stylebox.bg_color

		# Apply new color
		var new_stylebox = panel_stylebox.duplicate()
		new_stylebox.bg_color = COLORS[color_key]
		control.add_theme_stylebox_override(used_stylebox_name, new_stylebox)

		if DEBUG:
			print("[Warm Theme] Applied " + color_key + " to " + control.name + " using stylebox '" + used_stylebox_name + "'")
		return true
	else:
		if DEBUG:
			print("[Warm Theme] Could not find suitable stylebox for " + control.name)
		return false

func restore_original_theme():
	if DEBUG:
		print("[Warm Theme] Restoring original theme...")

	# Restore original colors
	for control in original_colors:
		if is_instance_valid(control):
			# Try different stylebox names
			var stylebox_names = ["panel", "tab_bg", "tabcontent", "panel_fg", "content", "content_panel", "background"]
			var restored = false

			for stylebox_name in stylebox_names:
				# Use a safe approach instead of try/except
				if control.has_theme_stylebox(stylebox_name):
					var panel_stylebox = control.get_theme_stylebox(stylebox_name)
					if panel_stylebox is StyleBoxFlat:
						var new_stylebox = panel_stylebox.duplicate()
						new_stylebox.bg_color = original_colors[control]
						control.add_theme_stylebox_override(stylebox_name, new_stylebox)
						restored = true

						if DEBUG:
							print("[Warm Theme] Restored original color for " + control.name + " using stylebox '" + stylebox_name + "'")
						break

			if not restored and DEBUG:
				print("[Warm Theme] Could not restore original color for " + control.name)
		else:
			if DEBUG:
				print("[Warm Theme] Control is no longer valid, skipping restoration")

	if DEBUG:
		print("[Warm Theme] Original theme restored")

# Helper functions to find UI elements
func _find_dock_containers():
	var containers = []
	var dock_slots = [
		"left_l", "left_r", "left_b", "left_t",
		"right_l", "right_r", "right_b", "right_t"
	]

	# Alternative names that might be used in different Godot versions
	var alt_dock_slots = [
		"dock_slot_0", "dock_slot_1", "dock_slot_2", "dock_slot_3",
		"dock_slot_4", "dock_slot_5", "dock_slot_6", "dock_slot_7"
	]

	# Try the primary names first
	for slot in dock_slots:
		var node = _find_node_by_name(get_editor_interface().get_base_control(), slot)
		if node and node is TabContainer:
			containers.append(node)

	# If we didn't find any, try the alternative names
	if containers.size() == 0:
		for slot in alt_dock_slots:
			var node = _find_node_by_name(get_editor_interface().get_base_control(), slot)
			if node and node is TabContainer:
				containers.append(node)

	# If we still didn't find any, try to find all TabContainers that might be docks
	if containers.size() == 0:
		var all_tab_containers = _find_all_nodes_of_type(get_editor_interface().get_base_control(), "TabContainer")
		for tab_container in all_tab_containers:
			# Only add tab containers that are likely to be docks (have tabs)
			if tab_container.get_tab_count() > 0:
				containers.append(tab_container)

	return containers

func _find_bottom_panel():
	# Try different possible names for the bottom panel
	var possible_names = ["BottomPanelContainer", "bottom_panel", "BottomPanel"]
	for name in possible_names:
		var node = _find_node_by_name(get_editor_interface().get_base_control(), name)
		if node:
			return node

	# If not found by name, try to find by position (at the bottom of the editor)
	var base = get_editor_interface().get_base_control()
	var candidates = []

	# Find all PanelContainers
	var all_panels = _find_all_nodes_of_type(base, "PanelContainer")
	for panel in all_panels:
		# Check if it's at the bottom of the editor
		if panel.get_global_position().y > base.get_size().y * 0.7:
			candidates.append(panel)

	# Return the bottom-most panel
	if candidates.size() > 0:
		candidates.sort_custom(func(a, b): return a.get_global_position().y > b.get_global_position().y)
		return candidates[0]

	return null

func _find_main_container():
	# Try different possible names for the main container
	var possible_names = ["Center", "CenterContainer", "center_container", "EditorViewport"]
	for name in possible_names:
		var node = _find_node_by_name(get_editor_interface().get_base_control(), name)
		if node:
			return node

	return null

func _find_toolbar():
	# Try different possible names for the toolbar
	var possible_names = ["ToolBar", "toolbar", "EditorToolBar", "MainToolBar"]
	for name in possible_names:
		var node = _find_node_by_name(get_editor_interface().get_base_control(), name)
		if node:
			return node

	return null

func _find_play_buttons():
	# Try different possible names for the play buttons
	var possible_names = ["PlayButtons", "play_buttons", "EditorPlayButtons"]
	for name in possible_names:
		var node = _find_node_by_name(get_editor_interface().get_base_control(), name)
		if node:
			return node

	return null

func _find_editor_tabs():
	# Try different possible names for the editor tabs
	var possible_names = ["EditorTabs", "editor_tabs", "ScriptTabs"]
	for name in possible_names:
		var node = _find_node_by_name(get_editor_interface().get_base_control(), name)
		if node:
			return node

	# If not found by name, try to find all TabContainers and pick the one that's likely to be the script editor
	var all_tab_containers = _find_all_nodes_of_type(get_editor_interface().get_base_control(), "TabContainer")
	for tab_container in all_tab_containers:
		# Check if any tab has a name that suggests it's a script
		for i in range(tab_container.get_tab_count()):
			var tab_title = tab_container.get_tab_title(i)
			if tab_title.ends_with(".gd") or tab_title.ends_with(".cs") or tab_title.ends_with(".gdshader"):
				return tab_container

	return null

func _find_node_by_name(node, name):
	if node.name == name:
		return node

	for child in node.get_children():
		var found = _find_node_by_name(child, name)
		if found:
			return found

	return null

# Helper function to find all nodes of a specific type
func _find_all_nodes_of_type(node, node_type_name):
	var result = []

	# Check if the node is of the specified type
	if node.get_class() == node_type_name or node.is_class(node_type_name):
		result.append(node)

	for child in node.get_children():
		result.append_array(_find_all_nodes_of_type(child, node_type_name))

	return result
