class_name InventoryController
extends RefCounted

signal moved(from_index: int, to_index: int)
signal rejected(from_index: int, to_index: int)

var inventory: InventoryData

func _init(target_inventory: InventoryData = null) -> void:
    inventory = target_inventory

func move_item(from_index: int, to_index: int) -> bool:
    if inventory == null or not inventory.is_valid_slot(from_index) or not inventory.is_valid_slot(to_index) or from_index == to_index:
        rejected.emit(from_index, to_index)
        return false
    var source := inventory.get_slot(from_index)
    var target := inventory.get_slot(to_index)
    if source == null or source.is_empty():
        rejected.emit(from_index, to_index)
        return false
    if target == null or target.is_empty():
        inventory.set_slot(to_index, source)
        inventory.clear_slot(from_index)
    elif not merge_stacks(from_index, to_index):
        inventory.swap_slots(from_index, to_index)
    moved.emit(from_index, to_index)
    return true

func merge_stacks(from_index: int, to_index: int) -> bool:
    if inventory == null:
        return false
    var source := inventory.get_slot(from_index)
    var target := inventory.get_slot(to_index)
    if source == null or target == null or source.is_empty() or target.is_empty() or source.item == null or target.item == null:
        return false
    if source.item.id != target.item.id:
        return false
    var transfer := min(source.amount, max(0, target.item.stack_size - target.amount))
    if transfer <= 0:
        return false
    target.amount += transfer
    source.amount -= transfer
    inventory.set_slot(to_index, target)
    inventory.set_slot(from_index, ItemStack.new() if source.amount <= 0 else source)
    return true

func remove_item(index: int, amount: int = 1) -> int:
    return inventory.remove_item(index, amount) if inventory != null else 0

func add_item(item: ItemData, amount: int = 1) -> int:
    return inventory.add_item(item, amount) if inventory != null else 0
