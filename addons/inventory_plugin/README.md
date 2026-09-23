# Editor workflow

The plugin is split into two independent components:

- `InventoryData`: a small `Resource` containing rows, columns, and `ItemStack` values. It has no UI references.
- `InventoryView`: a `Control` that displays an `InventoryData` resource and sends movement operations through `InventoryController`.

## Editor preview

`InventoryView` is an `@tool` control. Add it to a scene and assign an `InventoryPreset` resource. With no inventory assigned, the view renders an editor preview using `editor_rows` and `editor_columns` (or the preset's preview dimensions). Change slot size, spacing, textures, colors, icon scale, and scrollbar settings in the Inspector and the 2D preview updates without running the scene.

The `InventoryView` node itself is a normal `Control`, so its position, size, anchors, and scale can be changed and dragged in the 2D editor. The preset controls the repeated slot appearance; the view controls where and how large the inventory is in the scene.

## Saving presets

Create an `InventoryPreset` resource from the Inspector, edit it, then save it as a `.tres` file. For example:

- `player_inventory_preset.tres`
- `chest_inventory_preset.tres`
- `barrel_inventory_preset.tres`

Each view can reference a different preset while using the same inventory data component. Godot automatically serializes exported textures, colors, dimensions, and other preset properties into the resource file.

## Runtime usage

```gdscript
var data := InventoryData.new(4, 8)
var view := InventoryView.new()
view.inventory_data = data
view.preset = load("res://inventory/player_inventory_preset.tres")
add_child(view)
```

The editor preview does not create or save items. Assign an `InventoryData` resource when you want to preview actual item contents. Otherwise it remains a visual layout preview.
