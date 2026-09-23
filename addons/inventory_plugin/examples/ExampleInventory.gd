extends Node2D

var inventory: InventoryData
var preset: InventoryPreset
var view: InventoryView

func _ready() -> void:
    inventory = InventoryData.new(4, 5)
    preset = InventoryPreset.new()
    preset.preset_name = "Demo Inventory"
    preset.slot_size = Vector2(64, 64)
    preset.cell_spacing = Vector2(8, 8)

    var sword := ItemData.new("sword", "Sword", "res://icon/sword.png", 1)
    var potion := ItemData.new("potion", "Potion", "res://icon/potion.png", 12)
    var ore := ItemData.new("ore", "Ore", "res://icon/ore.png", 20)

    inventory.add_item(sword, 1)
    inventory.add_item(potion, 5)
    inventory.add_item(ore, 20)

    view = InventoryView.new()
    view.inventory_data = inventory
    view.preset = preset
    add_child(view)
    view.position = Vector2(64, 64)
