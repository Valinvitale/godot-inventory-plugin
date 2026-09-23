@tool
class_name InventorySlot
extends PanelContainer

signal item_dropped(from_index: int, to_index: int)

var slot_index := -1
var inventory_data: InventoryData
var preset: InventoryPreset
var icon_rect: TextureRect
var count_label: Label
var _hovered := false

func setup(index: int, data: InventoryData, layout: InventoryPreset) -> void:
    slot_index = index
    inventory_data = data
    preset = layout
    custom_minimum_size = preset.slot_size if preset != null else Vector2(64, 64)

func _ready() -> void:
    _build_ui()
    mouse_entered.connect(_on_mouse_entered)
    mouse_exited.connect(_on_mouse_exited)
    if inventory_data != null and not inventory_data.slot_changed.is_connected(_on_slot_changed):
        inventory_data.slot_changed.connect(_on_slot_changed)
    _refresh_visuals()

func _build_ui() -> void:
    if icon_rect != null:
        return
    var margin := MarginContainer.new()
    margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    var padding := preset.icon_margin if preset != null else 6
    for side in ["left", "top", "right", "bottom"]:
        margin.add_theme_constant_override("margin_" + side, padding)
    add_child(margin)
    icon_rect = TextureRect.new()
    icon_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    icon_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
    margin.add_child(icon_rect)
    count_label = Label.new()
    count_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    count_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
    count_label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
    count_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    add_child(count_label)

func _on_mouse_entered() -> void:
    _hovered = true
    _refresh_visuals()

func _on_mouse_exited() -> void:
    _hovered = false
    _refresh_visuals()

func _on_slot_changed(index: int) -> void:
    if index == slot_index:
        _refresh_visuals()

func _refresh_visuals() -> void:
    if icon_rect == null or count_label == null:
        return
    var color := preset.slot_hover_color if _hovered else preset.slot_background_color if preset != null else Color.WHITE
    var texture := preset.slot_hover_texture if _hovered and preset != null else preset.slot_texture if preset != null else null
    add_theme_stylebox_override("panel", preset.make_slot_style(color, texture) if preset != null else StyleBoxFlat.new())
    icon_rect.texture = null
    count_label.text = ""
    var stack := inventory_data.get_slot(slot_index) if inventory_data != null else null
    if stack == null or stack.is_empty() or stack.item == null:
        return
    icon_rect.texture = stack.item.get_icon()
    if preset != null:
        icon_rect.scale = preset.icon_scale
    count_label.text = str(stack.amount) if stack.amount > 1 else ""
    tooltip_text = "%s\n%s" % [stack.item.name, stack.item.description] if preset == null or preset.tooltip_enabled else ""

func _get_drag_data(_at_position: Vector2) -> Variant:
    if Engine.is_editor_hint():
        return null
    var stack := inventory_data.get_slot(slot_index) if inventory_data != null else null
    if stack == null or stack.is_empty():
        return null
    var preview := TextureRect.new()
    preview.texture = icon_rect.texture
    preview.custom_minimum_size = (preset.slot_size if preset != null else Vector2(64, 64)) * (preset.drag_preview_scale if preset != null else 0.75)
    preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    set_drag_preview(preview)
    return {"inventory": inventory_data, "slot_index": slot_index}

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
    return not Engine.is_editor_hint() and data is Dictionary and data.get("inventory") == inventory_data and int(data.get("slot_index", -1)) != slot_index

func _drop_data(_at_position: Vector2, data: Variant) -> void:
    item_dropped.emit(int(data["slot_index"]), slot_index)
