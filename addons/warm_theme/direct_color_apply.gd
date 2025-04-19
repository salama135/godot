@tool
extends EditorScript

# This script directly applies colors to specific docks by their names
# Run it from the Godot editor to apply colors without using the plugin

func _run():
    print("\n=== DIRECT COLOR APPLY ===")
    
    # Define the warm color palette
    var colors = {
        "scene_dock": Color("#F9E0BB"),       # Light peach
        "filesystem_dock": Color("#F2D8B3"),  # Light tan
        "inspector_dock": Color("#F9C5D5"),   # Light pink
        "node_dock": Color("#FFCAAF"),        # Light coral
        "history_dock": Color("#FFE4C0"),     # Light amber
        "import_dock": Color("#F8D7A8"),      # Light gold
        "debug_dock": Color("#E8D0FF"),       # Light lavender
        
        "bottom_panel": Color("#F5CCA0"),     # Warm sand
        "script_editor": Color("#FFF4E3"),    # Cream
        
        "2d_editor": Color("#FFFAF2"),        # Off-white
        "3d_editor": Color("#FFF8E7"),        # Ivory
        
        "toolbar": Color("#F6D6A3"),          # Pale gold
        "playbuttons": Color("#FFD9B7"),      # Peach
    }
    
    # Define dock name mappings
    var dock_mappings = {
        # Common dock names in different Godot versions
        "SceneTreeDock": "scene_dock",
        "FileSystemDock": "filesystem_dock",
        "InspectorDock": "inspector_dock",
        "NodeDock": "node_dock",
        "HistoryDock": "history_dock",
        "ImportDock": "import_dock",
        "DebuggerEditorPlugin": "debug_dock",
        
        # Alternative names
        "Scene": "scene_dock",
        "FileSystem": "filesystem_dock",
        "Inspector": "inspector_dock",
        "Node": "node_dock",
        "History": "history_dock",
        "Import": "import_dock",
        "Debugger": "debug_dock",
    }
    
    var base = get_editor_interface().get_base_control()
    
    # Find all TabContainers
    var tab_containers = _find_all_nodes_of_type(base, "TabContainer")
    
    print("Found " + str(tab_containers.size()) + " TabContainers")
    
    # Apply colors to each TabContainer based on its name or content
    for i in range(tab_containers.size()):
        var tc = tab_containers[i]
        var color_key = ""
        
        # Try to match the container name directly
        if dock_mappings.has(tc.name):
            color_key = dock_mappings[tc.name]
        else:
            # Try to match by tab titles
            for j in range(tc.get_tab_count()):
                var tab_title = tc.get_tab_title(j)
                if dock_mappings.has(tab_title):
                    color_key = dock_mappings[tab_title]
                    break
        
        # If we still don't have a match, try partial matching
        if color_key == "":
            var tc_name = tc.name.to_lower()
            if "scene" in tc_name:
                color_key = "scene_dock"
            elif "file" in tc_name:
                color_key = "filesystem_dock"
            elif "inspector" in tc_name or "property" in tc_name:
                color_key = "inspector_dock"
            elif "node" in tc_name:
                color_key = "node_dock"
            elif "history" in tc_name:
                color_key = "history_dock"
            elif "import" in tc_name:
                color_key = "import_dock"
            elif "debug" in tc_name:
                color_key = "debug_dock"
        
        # Apply the color if we found a match
        if color_key != "":
            # Try different stylebox names
            var stylebox_names = ["panel", "tab_bg", "tabcontent", "panel_fg", "content"]
            var applied = false
            
            for stylebox_name in stylebox_names:
                if tc.has_theme_stylebox(stylebox_name):
                    var sb = tc.get_theme_stylebox(stylebox_name)
                    if sb is StyleBoxFlat:
                        var new_sb = sb.duplicate()
                        new_sb.bg_color = colors[color_key]
                        tc.add_theme_stylebox_override(stylebox_name, new_sb)
                        applied = true
                        print("Applied " + color_key + " to " + tc.name + " using stylebox '" + stylebox_name + "'")
                        break
            
            if not applied:
                print("Could not apply color to " + tc.name + " (no suitable stylebox found)")
        else:
            print("Could not determine color for " + tc.name)
    
    # Apply color to bottom panel
    var bottom_panel = _find_node_by_name(base, "BottomPanelContainer")
    if bottom_panel:
        _apply_color_to_control(bottom_panel, colors["bottom_panel"], ["panel", "content_panel", "background"])
    
    # Apply color to main editor area
    var center = _find_node_by_name(base, "Center")
    if center:
        _apply_color_to_control(center, colors["2d_editor"], ["panel", "content", "background"])
    
    print("=== DIRECT COLOR APPLY COMPLETE ===")

func _apply_color_to_control(control, color, stylebox_names):
    for stylebox_name in stylebox_names:
        if control.has_theme_stylebox(stylebox_name):
            var sb = control.get_theme_stylebox(stylebox_name)
            if sb is StyleBoxFlat:
                var new_sb = sb.duplicate()
                new_sb.bg_color = color
                control.add_theme_stylebox_override(stylebox_name, new_sb)
                print("Applied color to " + control.name + " using stylebox '" + stylebox_name + "'")
                return true
    
    print("Could not apply color to " + control.name + " (no suitable stylebox found)")
    return false

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
