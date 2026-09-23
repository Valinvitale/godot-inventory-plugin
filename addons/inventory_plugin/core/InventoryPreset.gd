class_name InventoryPreset
extends Resource

@export var preset_name: String = "Inventory Preset"
@export var rows: int = 4
@export var columns: int = 5
@export var slot_size: Vector2 = Vector2(64, 64)
@export var cell_spacing: Vector2 = Vector2(8, 8)
@export var slot_background_color: Color = Color(0.17, 0.17, 0.17, 1.0)
@export var selected_background_color: Color = Color(0.33, 0.52, 0.84, 1.0)
@export var icon_margin: Vector2 = Vector2(8, 8)
@export var show_scrollbar: bool = true
@export var slot_style: String = "default"

func _init() -> void:
    pass

func apply_to_view(view: Control) -> void:
    if view == null:
        return
    view.custom_minimum_size = Vector2(columns * slot_size.x, rows * slot_size.y)
