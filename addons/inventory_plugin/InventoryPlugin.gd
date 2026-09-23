@tool
extends EditorPlugin

func _enter_tree() -> void:
    # The inventory is intentionally not an autoload. Add InventoryData and
    # InventoryView only where a scene needs them.
    pass

func _exit_tree() -> void:
    pass
