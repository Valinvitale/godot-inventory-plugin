@tool
class_name InventoryView
extends Control

## Visual component only. It reads and edits InventoryData; it never owns items.
signal slot_selected(index: int)
signal item_moved(from_index: int, to_index: int)

@export var inventory_data: InventoryData:
    set(value):
        inventory_data = value
        _schedule_preview_refresh()
@export var preset: InventoryPreset:
    set(value):
        preset = value
        _schedule_preview_refresh()
@export_group("Editor Preview")
@export var preview_in_editor := true:
    set(value):
        preview_in_editor = value
        _schedule_preview_refresh()
@export_range(1, 999, 1) var editor_rows := 4:
    set(value):
        editor_rows = max(1, value)
        _schedule_preview_refresh()
@export_range(1, 999, 1) var editor_columns := 5:
    set(value):
        editor_columns = max(1, value)
        _schedule_preview_refresh()
@export_group("Interaction")
@export var allow_multiple_selection := false

var scroll_container: ScrollContainer
var grid: GridContainer
var controller: InventoryController
var selected_slots: Array[int] = []
var _refresh_queued := false

func _ready() -> void:
    if preset == null:
        preset = InventoryPreset.new()
    if inventory_data == null and not Engine.is_editor_hint():
        inventory_data = InventoryData.new()
    if inventory_data != null and not inventory_data.changed.is_connected(_rebuild_view):
        inventory_data.changed.connect(_rebuild_view)
    controller = InventoryController.new(inventory_data)
    _build_container()
    _rebuild_view()

func _notification(what: int) -> void:
    if what == NOTIFICATION_EDITOR_PROPERTY_CHANGED:
        _schedule_preview_refresh()

func _schedule_preview_refresh() -> void:
    if _refresh_queued or not is_inside_tree():
        return
    _refresh_queued = true
    call_deferred("_refresh_preview")

func _refresh_preview() -> void:
    _refresh_queued = false
    if is_inside_tree():
        _rebuild_view()

func _build_container() -> void:
    if scroll_container != null:
        return
    scroll_container = ScrollContainer.new()
    scroll_container.name = "InventoryScroll"
    scroll_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(scroll_container)
    grid = GridContainer.new()
    grid.name = "InventoryGrid"
    grid.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
    grid.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
    scroll_container.add_child(grid)

func _rebuild_view() -> void:
    if grid == null or preset == null:
        return
    for child in grid.get_children():
        child.queue_free()
    var rows := editor_rows
    var columns := editor_columns
    if inventory_data != null:
        rows = inventory_data.rows
        columns = inventory_data.columns
    elif preset != null:
        rows = preset.preview_rows
        columns = preset.preview_columns
    grid.columns = columns
    grid.add_theme_constant_override("h_separation", int(preset.cell_spacing.x))
    grid.add_theme_constant_override("v_separation", int(preset.cell_spacing.y))
    scroll_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO if preset.show_scrollbars else ScrollContainer.SCROLL_MODE_DISABLED
    scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO if preset.show_scrollbars else ScrollContainer.SCROLL_MODE_DISABLED
    for index in rows * columns:
        var slot := InventorySlot.new()
        slot.setup(index, inventory_data, preset)
        slot.item_dropped.connect(_on_item_dropped)
        slot.gui_input.connect(_on_slot_input.bind(index))
        grid.add_child(slot)

func _on_slot_input(event: InputEvent, index: int) -> void:
    if Engine.is_editor_hint():
        return
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        select_slot(index)
        slot_selected.emit(index)

func _on_item_dropped(from_index: int, to_index: int) -> void:
    if controller != null and controller.move_item(from_index, to_index):
        item_moved.emit(from_index, to_index)

func set_inventory(new_inventory: InventoryData) -> void:
    if inventory_data != null and inventory_data.changed.is_connected(_rebuild_view):
        inventory_data.changed.disconnect(_rebuild_view)
    inventory_data = new_inventory
    controller = InventoryController.new(inventory_data)
    if inventory_data != null:
        inventory_data.changed.connect(_rebuild_view)
    _rebuild_view()

func set_preset(new_preset: InventoryPreset) -> void:
    preset = new_preset if new_preset != null else InventoryPreset.new()
    _rebuild_view()

func select_slot(index: int) -> void:
    if not allow_multiple_selection:
        selected_slots.clear()
    if selected_slots.has(index):
        selected_slots.erase(index)
    else:
        selected_slots.append(index)

func get_controller() -> InventoryController:
    return controller
