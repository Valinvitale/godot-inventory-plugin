class_name InventorySlot
extends PanelContainer

@export var slot_index: int = -1
@export var inventory_data: InventoryData
@export var preset: InventoryPreset
@export var is_selected: bool = false

var icon_rect: TextureRect
var count_label: Label

func _ready() -> void:
    _build_ui()
    gui_input.connect(_on_gui_input)
    if inventory_data != null:
        inventory_data.changed.connect(_refresh_visuals)
    _refresh_visuals()

func _build_ui() -> void:
    if icon_rect == null:
        icon_rect = TextureRect.new()
        icon_rect.name = "IconRect"
        icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
        icon_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
        icon_rect.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
        icon_rect.size_flags_vertical = Control.SIZE_SHRINK_CENTER
        add_child(icon_rect)

    if count_label == null:
        count_label = Label.new()
        count_label.name = "CountLabel"
        count_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
        count_label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
        count_label.anchors_preset = PRESET_FULL_RECT
        count_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        count_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
        add_child(count_label)

func _refresh_visuals() -> void:
    if preset != null:
        custom_minimum_size = preset.slot_size
        self.modulate = preset.slot_background_color
        if is_selected:
            self.modulate = preset.selected_background_color

    if inventory_data == null or slot_index < 0 or slot_index >= inventory_data.slots.size():
        icon_rect.texture = null
        count_label.text = ""
        return

    var stack: ItemStack = inventory_data.get_slot(slot_index)
    if stack == null or stack.is_empty():
        icon_rect.texture = null
        count_label.text = ""
        return

    if stack.item != null and stack.item.icon_path != "":
        var loaded_texture: Texture2D = load(stack.item.icon_path)
        if loaded_texture != null:
            icon_rect.texture = loaded_texture

    if stack.amount > 1:
        count_label.text = str(stack.amount)
    else:
        count_label.text = ""

func _on_gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        is_selected = not is_selected
        _refresh_visuals()
