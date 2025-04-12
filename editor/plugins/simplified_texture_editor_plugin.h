#pragma once

#include "editor/plugins/editor_plugin.h"
#include "editor/editor_properties.h"
#include "editor/editor_resource_picker.h"
#include "scene/2d/sprite_2d.h"

class EditorInspectorPluginSimplifiedTexture : public EditorInspectorPlugin {
    GDCLASS(EditorInspectorPluginSimplifiedTexture, EditorInspectorPlugin);

public:
    virtual bool can_handle(Object *p_object) override;
    virtual bool parse_property(Object *p_object, const Variant::Type p_type, const String &p_path, const PropertyHint p_hint, const String &p_hint_text, const BitField<PropertyUsageFlags> p_usage, const bool p_wide) override;
};

class SimplifiedTextureEditorPlugin : public EditorPlugin {
    GDCLASS(SimplifiedTextureEditorPlugin, EditorPlugin);

public:
    SimplifiedTextureEditorPlugin();
};
