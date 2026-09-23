class_name ItemData
extends Resource

@export var id: String = ""
@export var name: String = "Item"
@export var icon: Texture2D
@export_file("*.png", "*.jpg", "*.jpeg", "*.webp", "*.svg") var icon_path: String = ""
@export_range(1, 999999, 1) var stack_size: int = 1
@export_multiline var description: String = ""
@export var metadata: Dictionary = {}
@export var tags: Array[String] = []

func _init(p_id: String = "", p_name: String = "Item", p_icon_path: String = "", p_stack_size: int = 1) -> void:
    id = p_id
    name = p_name
    icon_path = p_icon_path
    stack_size = max(1, p_stack_size)

func get_icon() -> Texture2D:
    if icon != null:
        return icon
    if icon_path != "":
        return load(icon_path) as Texture2D
    return null

func clone() -> ItemData:
    var copy := ItemData.new(id, name, icon_path, stack_size)
    copy.icon = icon
    copy.description = description
    copy.metadata = metadata.duplicate(true)
    copy.tags = tags.duplicate()
    return copy
