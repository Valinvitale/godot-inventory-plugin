# Inventory Plugin API

## Runtime

`InventoryData` is a `Resource` and contains only inventory state. `ItemData` and `ItemStack` are also resources, so they can be authored in the inspector or saved as `.tres` files.

`InventoryView` is the presentation layer. Assign any `InventoryData` and `InventoryPreset` to it, and it creates a scrollable grid automatically. Multiple views can point at different inventories or share one inventory with different presets.

`InventoryController` contains the default movement policy: empty-slot moves, stack merging, and swaps. Replace it or wrap it when a game needs restrictions such as equipment slot types, locked slots, or permissions.

## Drag/drop

The built-in slot controls use Godot's `Control` drag/drop API. Dragging a populated slot to another slot calls the controller and performs a merge or swap.

## Presets

`InventoryPreset` is a `Resource`. Save it from the Godot editor as a `.tres` file, then reuse it for player, chest, barrel, or other views. It controls slot sizing, spacing, colors, borders, icon padding, scrollbars, and tooltip behavior.

## Extension points

- Connect `InventoryView.slot_selected` for selection systems.
- Connect `InventoryView.item_moved` for sound, quests, analytics, or multiplayer replication.
- Subclass `InventoryController` for custom movement validation.
- Add tooltip, filter, context-menu, or hotbar controls around `InventoryView` without coupling them to `InventoryData`.
