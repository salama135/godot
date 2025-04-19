@tool
extends EditorScript

# This script helps identify the dock structure in the current Godot version
# Run it from the Godot editor to print detailed information about the docks

func _run():
    print("\n=== DOCK INSPECTOR ===")
    var base = get_editor_interface().get_base_control()
    
    # Find all TabContainers
    var tab_containers = _find_all_nodes_of_type(base, "TabContainer")
    
    print("\nFound " + str(tab_containers.size()) + " TabContainers:")
    for i in range(tab_containers.size()):
        var tc = tab_containers[i]
        print("\n" + str(i) + ": " + tc.name + " (tabs: " + str(tc.get_tab_count()) + ")")
        print("  Global position: " + str(tc.get_global_position()))
        print("  Size: " + str(tc.get_size()))
        
        # Print tab titles
        if tc.get_tab_count() > 0:
            print("  Tabs:")
            for j in range(tc.get_tab_count()):
                print("    " + str(j) + ": " + tc.get_tab_title(j))
        
        # Print parent hierarchy
        var parent_info = "  Parent hierarchy: "
        var parent = tc.get_parent()
        while parent != null:
            parent_info += parent.name
            parent = parent.get_parent()
            if parent != null:
                parent_info += " <- "
        print(parent_info)
        
        # Try to determine what kind of dock this is
        var dock_type = _identify_dock_type(tc)
        print("  Likely dock type: " + dock_type)
    
    print("\n=== END OF DOCK INSPECTOR ===")

func _identify_dock_type(container):
    # Try to identify the dock by its name or content
    var dock_name = container.name.to_lower()
    
    if "scene" in dock_name or "node" in dock_name:
        return "Scene Dock"
    elif "file" in dock_name or "fs" in dock_name or "filesystem" in dock_name:
        return "FileSystem Dock"
    elif "inspector" in dock_name or "property" in dock_name:
        return "Inspector Dock"
    elif "history" in dock_name:
        return "History Dock"
    elif "import" in dock_name:
        return "Import Dock"
    elif "debug" in dock_name:
        return "Debug Dock"
    
    # If we couldn't identify by name, try by tab titles
    for j in range(container.get_tab_count()):
        var tab_title = container.get_tab_title(j).to_lower()
        if "scene" in tab_title or "node" in tab_title:
            return "Scene Dock"
        if "file" in tab_title or "fs" in tab_title or "filesystem" in tab_title:
            return "FileSystem Dock"
        if "inspector" in tab_title or "property" in tab_title:
            return "Inspector Dock"
        if "history" in tab_title:
            return "History Dock"
        if "import" in tab_title:
            return "Import Dock"
        if "debug" in tab_title:
            return "Debug Dock"
    
    # If we still couldn't identify, check the position
    var pos = container.get_global_position()
    if pos.x < 300:
        return "Left Dock (Scene/FileSystem?)"
    elif pos.x > 700:
        return "Right Dock (Inspector/Node?)"
    else:
        return "Unknown Dock"

# Helper function to find all nodes of a specific type
func _find_all_nodes_of_type(node, node_type_name):
    var result = []
    
    # Check if the node is of the specified type
    if node.get_class() == node_type_name or node.is_class(node_type_name):
        result.append(node)
    
    for child in node.get_children():
        result.append_array(_find_all_nodes_of_type(child, node_type_name))
    
    return result
