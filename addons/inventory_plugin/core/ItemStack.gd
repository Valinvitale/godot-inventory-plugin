class_name ItemStack
extends Resource

@export var item: ItemData
@export var amount: int = 0

func _init(p_item: ItemData = null, p_amount: int = 0) -> void:
    item = p_item
    amount = max(0, p_amount)

func is_empty() -> bool:
    return item == null or amount <= 0

func clear() -> void:
    item = null
    amount = 0

func clone() -> ItemStack:
    if item == null:
        return ItemStack.new(null, 0)
    return ItemStack.new(item.clone(), amount)
