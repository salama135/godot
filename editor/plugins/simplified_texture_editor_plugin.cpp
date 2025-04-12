#include "simplified_texture_editor_plugin.h"
#include "editor/editor_node.h"
#include "editor/themes/editor_scale.h"
#include "editor/editor_settings.h"

class SimplifiedEditorResourcePicker : public EditorResourcePicker {
    GDCLASS(SimplifiedEditorResourcePicker, EditorResourcePicker);

    // Define our own enum values for menu options
    enum {
        MENU_QUICK_LOAD = 100,
        MENU_LOAD = 101
    };

public:
    virtual void set_create_options(Object *p_menu_node) override {
        PopupMenu *menu_node = Object::cast_to<PopupMenu>(p_menu_node);
        if (!menu_node) {
            return;
        }

        // Only add the Load and Quick Load options
        // menu_node->add_icon_item(get_editor_theme_icon(SNAME("Load")), TTR("Quick Load..."), MENU_QUICK_LOAD);
        // menu_node->set_item_tooltip(-1, TTR("Opens a quick menu to select from a list of allowed Resource files."));

        // menu_node->add_icon_item(get_editor_theme_icon(SNAME("Load")), TTR("Load..."), MENU_LOAD);

        // Add a hidden dummy item to prevent the "inheritors_array.is_empty()" error
        // menu_node->add_separator();
        // menu_node->add_item("Dummy", 999);
        // menu_node->set_item_hidden(-1, true);
    }

    virtual bool handle_menu_selected(int p_which) override {
        // Handle our custom menu options
        if (p_which == MENU_QUICK_LOAD) {
            // Call the parent class's handle_menu_selected with the original enum value
            // This is a bit of a hack, but it works because the parent class's enum values are private
            return EditorResourcePicker::handle_menu_selected(67); // OBJ_MENU_QUICKLOAD
        } else if (p_which == MENU_LOAD) {
            return EditorResourcePicker::handle_menu_selected(66); // OBJ_MENU_LOAD
        }

        return EditorResourcePicker::handle_menu_selected(p_which);
    }
};

class SimplifiedEditorPropertyTexture : public EditorPropertyResource {
    GDCLASS(SimplifiedEditorPropertyTexture, EditorPropertyResource);

private:
    // We need to define our own resource handling methods since the parent's are private
    void _resource_selected_override(const Ref<Resource> &p_resource, bool p_inspect) {
        emit_changed(get_edited_property(), p_resource);
    }

    void _resource_changed_override(const Ref<Resource> &p_resource) {
        emit_changed(get_edited_property(), p_resource);
    }

public:
    void setup(Object *p_object, const String &p_path, const String &p_base_type) {
        // First, call the parent setup to create the default UI
        EditorPropertyResource::setup(p_object, p_path, p_base_type);

        // We need to remove all children and recreate our own picker
        // since we can't access the private resource_picker member
        for (int i = get_child_count() - 1; i >= 0; i--) {
            Node *child = get_child(i);
            remove_child(child);
            memdelete(child);
        }

        // Create our custom resource picker
        SimplifiedEditorResourcePicker *custom_picker = memnew(SimplifiedEditorResourcePicker);
        custom_picker->set_base_type(p_base_type);
        custom_picker->set_resource_owner(p_object);
        custom_picker->set_editable(!is_read_only());
        custom_picker->set_h_size_flags(SIZE_EXPAND_FILL);
        add_child(custom_picker);

        // Connect signals to our own methods
        custom_picker->connect("resource_selected", callable_mp(this, &SimplifiedEditorPropertyTexture::_resource_selected_override));
        custom_picker->connect("resource_changed", callable_mp(this, &SimplifiedEditorPropertyTexture::_resource_changed_override));

        // Set the current resource if any
        if (get_edited_object() && get_edited_property()) {
            Ref<Resource> res = get_edited_object()->get(get_edited_property());
            if (res.is_valid()) {
                custom_picker->set_edited_resource(res);
            }
        }

        // Add focusable buttons
        for (int i = 0; i < custom_picker->get_child_count(); i++) {
            Button *b = Object::cast_to<Button>(custom_picker->get_child(i));
            if (b) {
                add_focusable(b);
            }
        }
    }
};

bool EditorInspectorPluginSimplifiedTexture::can_handle(Object *p_object) {
    return Object::cast_to<Sprite2D>(p_object) != nullptr;
}

bool EditorInspectorPluginSimplifiedTexture::parse_property(Object *p_object, const Variant::Type p_type, const String &p_path, const PropertyHint p_hint, const String &p_hint_text, const BitField<PropertyUsageFlags> p_usage, const bool p_wide) {
    if (p_type == Variant::OBJECT && p_path == "texture" && p_hint == PROPERTY_HINT_RESOURCE_TYPE && p_hint_text.begins_with("Texture2D")) {
        SimplifiedEditorPropertyTexture *editor = memnew(SimplifiedEditorPropertyTexture);
        editor->setup(p_object, p_path, p_hint_text);
        add_property_editor(p_path, editor);
        return true;
    }
    return false;
}

SimplifiedTextureEditorPlugin::SimplifiedTextureEditorPlugin() {
    Ref<EditorInspectorPluginSimplifiedTexture> plugin;
    plugin.instantiate();
    add_inspector_plugin(plugin);
}
