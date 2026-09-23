class_name InventoryPreset
extends Resource

@export var preset_name := "Inventory Preset"
@export var slot_size := Vector2(64, 64)
@export var cell_spacing := Vector2(8, 8)
@export var panel_padding := Vector4(12, 12, 12, 12)
@export var slot_background_color := Color(0.12, 0.14, 0.18, 1.0)
@export var slot_hover_color := Color(0.22, 0.28, 0.38, 1.0)
@export var slot_selected_color := Color(0.25, 0.52, 0.90, 1.0)
@export var slot_border_color := Color(0.35, 0.40, 0.48, 1.0)
@export var slot_border_width := 1
@export var icon_margin := 6
@export var show_scrollbars := true
@export var tooltip_enabled := true
@export var drag_preview_scale := 0.75

func make_slot_style(color: Color) -> StyleBoxFlat:
    var style := StyleBoxFlat.new()
    style.bg_color = color
    style.border_color = slot_border_color
    style.set_border_width_all(slot_border_width)
    style.corner_radius_top_left = 4
    style.corner_radius_top_right = 4
    style.corner_radius_bottom_left = 4
    style.corner_radius_bottom_right = 4
    return style
