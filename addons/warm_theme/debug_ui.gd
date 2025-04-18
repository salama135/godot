@tool
extends EditorScript

# This script helps debug the editor's UI structure
# Run it from the Godot editor to print information about the UI elements

func _run():
	print("\n=== EDITOR UI DEBUG ===")
	var base = get_editor_interface().get_base_control()

	# Print all TabContainers
	print("\n--- TabContainers ---")
	var tab_containers = _find_all_nodes_of_type(base, "TabContainer")
	for i in range(tab_containers.size()):
		var tc = tab_containers[i]
		print(str(i) + ": " + tc.name + " (tabs: " + str(tc.get_tab_count()) + ")")

		# Print tab titles
		for j in range(tc.get_tab_count()):
			print("  Tab " + str(j) + ": " + tc.get_tab_title(j))

		# Print styleboxes
		print("  Styleboxes:")
		_print_styleboxes(tc)

	# Print all PanelContainers
	print("\n--- PanelContainers ---")
	var panel_containers = _find_all_nodes_of_type(base, "PanelContainer")
	for i in range(panel_containers.size()):
		var pc = panel_containers[i]
		print(str(i) + ": " + pc.name + " at position " + str(pc.get_global_position()))

		# Print styleboxes
		print("  Styleboxes:")
		_print_styleboxes(pc)

	# Print other important UI elements
	print("\n--- Important UI Elements ---")
	var important_names = [
		"ToolBar", "toolbar", "EditorToolBar", "MainToolBar",
		"PlayButtons", "play_buttons", "EditorPlayButtons",
		"Center", "CenterContainer", "center_container", "EditorViewport",
		"BottomPanelContainer", "bottom_panel", "BottomPanel",
		"EditorTabs", "editor_tabs", "ScriptTabs"
	]

	for name in important_names:
		var node = _find_node_by_name(base, name)
		if node:
			print(name + " found: " + node.get_class())
			print("  Styleboxes:")
			_print_styleboxes(node)

	print("\n=== END OF DEBUG ===")

func _print_styleboxes(control):
	var stylebox_names = [
		"panel", "tab_bg", "tabcontent", "panel_fg", "content",
		"content_panel", "background", "normal"
	]

	for name in stylebox_names:
		# Use a safe approach instead of try/except
		if control.has_theme_stylebox(name):
			var sb = control.get_theme_stylebox(name)
			if sb:
				print("    " + name + ": " + sb.get_class())
				if sb is StyleBoxFlat:
					print("      bg_color: " + sb.bg_color.to_html())

# Helper function to find all nodes of a specific type
func _find_all_nodes_of_type(node, node_type_name):
	var result = []

	# Check if the node is of the specified type
	if node.get_class() == node_type_name or node.is_class(node_type_name):
		result.append(node)

	for child in node.get_children():
		result.append_array(_find_all_nodes_of_type(child, node_type_name))

	return result

# Helper function to find a node by name
func _find_node_by_name(node, name):
	if node.name == name:
		return node

	for child in node.get_children():
		var found = _find_node_by_name(child, name)
		if found:
			return found

	return null
