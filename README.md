# Godot Inventory Plugin

A Godot 4.6.3 plugin for building data-first, UI-editable, extensible inventory systems.

This project is built around the following design goals:
- separation of inventory data from UI code
- multiple inventory UI presets saved as resources/files
- support for custom slot visuals, positions, scaling, and backgrounds
- row x column inventory sizing
- scrolling when the layout exceeds the available space
- shared movement logic for drag/drop, swapping, and stacking
- easy extension points for filters, tooltips, hotbars, context menus, and more

## Target version
- Godot 4.6.3

## Plugin structure
- `addons/inventory_plugin/` contains the plugin code
- `core/` contains the data model and resource types
- `controllers/` contains movement and inventory logic
- `ui/` contains the visual inventory and slot widgets
- `examples/` contains a small example script

## Quick usage

1. Copy the `addons` folder into your Godot project.
2. Enable the plugin in Project > Project Settings > Plugins.
3. Instantiate `InventoryData` and `InventoryPreset`.
4. Create an `InventoryView` and attach it to your scene.
5. Add items and connect controllers.

Example:

```gdscript
extends Node2D

var inventory: InventoryData
var preset: InventoryPreset
var view: InventoryView

func _ready() -> void:
    inventory = InventoryData.new(4, 5)
    preset = InventoryPreset.new()
    preset.preset_name = "Player Inventory"
    preset.slot_size = Vector2(64, 64)
    preset.cell_spacing = Vector2(6, 6)

    var sword := ItemData.new("sword", "Sword", "res://art/sword.png", 1)
    inventory.add_item(sword, 1)

    view = InventoryView.new()
    view.inventory_data = inventory
    view.preset = preset
    add_child(view)
```

## Included features
- inventory data model with rows/columns and slot array
- item stack support
- drag-and-drop style movement API through `InventoryController`
- inventory UI view that renders slots automatically
- easy inventory preset creation and editing
- multiple inventory layouts with the same data model
- ready-made extension points for future features

## Notes
This is a practical starter plugin scaffold, intentionally structured to be extended. It covers the key architecture and runtime behavior while remaining simple enough to build on.

## License
MIT
