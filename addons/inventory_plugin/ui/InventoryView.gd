class_name InventoryView
extends Control

signal slot_selected(index: int)
signal item_moved(from_index: int, to_index: int)

@export var inventory_data: InventoryData
@export var preset: InventoryPreset
@export var allow_multiple_selection := false

var scroll_container: ScrollContainer
var grid: GridContainer
var controller: InventoryController
var selected_slots: Array[int] = []

func _ready() -> void:
    if inventory_data == null:
        inventory_data = InventoryData.new()
    if preset == null:
        preset = InventoryPreset.new()
    controller = InventoryController.new(inventory_data)
    if not inventory_data.changed.is_connected(_rebuild_view):
        inventory_data.changed.connect(_rebuild_view)
    _build_container()
    _rebuild_view()

func _build_container() -> void:
    scroll_container = ScrollContainer.new()
    scroll_container.name = "InventoryScroll"
    scroll_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    scroll_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO if preset.show_scrollbars else ScrollContainer.SCROLL_MODE_DISABLED
    scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO if preset.show_scrollbars else ScrollContainer.SCROLL_MODE_DISABLED
    add_child(scroll_container)
    grid = GridContainer.new()
    grid.name = "InventoryGrid"
    grid.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
    grid.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
    scroll_container.add_child(grid)

func _rebuild_view() -> void:
    if not is_inside_tree() or grid == null:
        return
    for child in grid.get_children():
        child.queue_free()
    grid.columns = inventory_data.columns
    grid.add_theme_constant_override("h_separation", int(preset.cell_spacing.x))
    grid.add_theme_constant_override("v_separation", int(preset.cell_spacing.y))
    for index in inventory_data.slot_count():
        var slot := InventorySlot.new()
        slot.setup(index, inventory_data, preset)
        slot.item_dropped.connect(_on_item_dropped)
        slot.gui_input.connect(_on_slot_input.bind(index))
        grid.add_child(slot)

func _on_slot_input(event: InputEvent, index: int) -> void:
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        select_slot(index)
        slot_selected.emit(index)

func _on_item_dropped(from_index: int, to_index: int) -> void:
    if controller.move_item(from_index, to_index):
        item_moved.emit(from_index, to_index)

func set_inventory(new_inventory: InventoryData) -> void:
    if inventory_data != null and inventory_data.changed.is_connected(_rebuild_view):
        inventory_data.changed.disconnect(_rebuild_view)
    inventory_data = new_inventory if new_inventory != null else InventoryData.new()
    controller = InventoryController.new(inventory_data)
    inventory_data.changed.connect(_rebuild_view)
    _rebuild_view()

func set_preset(new_preset: InventoryPreset) -> void:
    preset = new_preset if new_preset != null else InventoryPreset.new()
    if scroll_container != null:
        scroll_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO if preset.show_scrollbars else ScrollContainer.SCROLL_MODE_DISABLED
        scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO if preset.show_scrollbars else ScrollContainer.SCROLL_MODE_DISABLED
    _rebuild_view()

func select_slot(index: int) -> void:
    if not allow_multiple_selection:
        selected_slots.clear()
    if selected_slots.has(index):
        selected_slots.erase(index)
    else:
        selected_slots.append(index)
    for slot in grid.get_children():
        if slot is InventorySlot:
            slot._refresh_visuals()

func get_controller() -> InventoryController:
    return controller
