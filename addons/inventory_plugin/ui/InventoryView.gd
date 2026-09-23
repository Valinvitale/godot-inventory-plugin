class_name InventoryView
extends Control

@export var inventory_data: InventoryData
@export var preset: InventoryPreset
@export var selected_slots: Array[int] = []

var grid: GridContainer
var controller: InventoryController

func _ready() -> void:
    if inventory_data == null:
        inventory_data = InventoryData.new()
    if preset == null:
        preset = InventoryPreset.new()
    controller = InventoryController.new(inventory_data)
    inventory_data.changed.connect(_rebuild_view)
    _rebuild_view()

func _rebuild_view() -> void:
    if grid != null and is_instance_valid(grid):
        grid.queue_free()

    grid = GridContainer.new()
    grid.name = "InventoryGrid"
    grid.columns = inventory_data.columns
    grid.mouse_filter = Control.MOUSE_FILTER_PASS
    if preset != null:
        grid.add_theme_constant_override("h_separation", int(preset.cell_spacing.x))
        grid.add_theme_constant_override("v_separation", int(preset.cell_spacing.y))
    add_child(grid)

    for i in range(inventory_data.slot_count()):
        var slot := InventorySlot.new()
        slot.slot_index = i
        slot.inventory_data = inventory_data
        slot.preset = preset
        slot.custom_minimum_size = preset.slot_size if preset != null else Vector2(64, 64)
        if selected_slots.has(i):
            slot.is_selected = true
        grid.add_child(slot)

func set_inventory(new_inventory: InventoryData) -> void:
    inventory_data = new_inventory
    controller = InventoryController.new(inventory_data)
    _rebuild_view()

func get_controller() -> InventoryController:
    return controller

func select_slot(index: int) -> void:
    if selected_slots.has(index):
        selected_slots.erase(index)
    else:
        selected_slots.append(index)
    _rebuild_view()
