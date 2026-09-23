# Godot 4.6.3 Inventory Plugin
# Copyright (c) 2026
# License: MIT

class_name ItemData
extends Resource

@export var id: String = ""
@export var name: String = "Item"
@export var icon_path: String = ""
@export var stack_size: int = 1
@export var description: String = ""
@export var metadata: Dictionary = {}
@export var tags: Array[String] = []

func _init(p_id: String = "", p_name: String = "Item", p_icon_path: String = "", p_stack_size: int = 1) -> void:
    id = p_id
    name = p_name
    icon_path = p_icon_path
    stack_size = max(1, p_stack_size)

func clone() -> ItemData:
    var copy := ItemData.new(id, name, icon_path, stack_size)
    copy.description = description
    copy.metadata = metadata.duplicate(true)
    copy.tags = tags.duplicate()
    return copy
