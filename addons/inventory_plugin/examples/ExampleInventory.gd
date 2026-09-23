extends Node

## Minimal runtime example. Attach this to a Node in a test scene.
func _ready() -> void:
    var inventory := InventoryData.new(6, 8)
    var preset := load("res://addons/inventory_plugin/examples/player_inventory_preset.tres") as InventoryPreset
    var potion := ItemData.new("potion", "Potion", "res://icon.svg", 20)
    potion.description = "Restores health."
    inventory.add_item(potion, 27)
    var view := InventoryView.new()
    view.set_inventory(inventory)
    view.set_preset(preset)
    view.custom_minimum_size = Vector2(520, 360)
    add_child(view)
