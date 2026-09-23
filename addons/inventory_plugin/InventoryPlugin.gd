@tool
extends EditorPlugin

const VERSION := "0.2.0"

func _enter_tree() -> void:
    add_autoload_singleton("InventoryPlugin", "res://addons/inventory_plugin/InventoryPlugin.gd")

func _exit_tree() -> void:
    remove_autoload_singleton("InventoryPlugin")
