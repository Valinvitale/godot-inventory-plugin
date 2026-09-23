class_name InventoryController
extends RefCounted

var inventory: InventoryData

func _init(target_inventory: InventoryData) -> void:
    inventory = target_inventory

func move_item(from_index: int, to_index: int) -> bool:
    if inventory == null:
        return false
    if from_index < 0 or to_index < 0:
        return false
    if from_index == to_index:
        return false

    var source_stack: ItemStack = inventory.get_slot(from_index)
    var target_stack: ItemStack = inventory.get_slot(to_index)

    if source_stack == null or source_stack.is_empty():
        return false

    if target_stack == null or target_stack.is_empty():
        inventory.set_slot(to_index, source_stack)
        inventory.set_slot(from_index, ItemStack.new())
        return true

    if source_stack.item != null and target_stack.item != null:
        if source_stack.item.id == target_stack.item.id and source_stack.item.stack_size > 1:
            if merge_stacks(from_index, to_index):
                return true

    inventory.swap_slots(from_index, to_index)
    return true

func merge_stacks(from_index: int, to_index: int) -> bool:
    if inventory == null:
        return false

    var source_stack: ItemStack = inventory.get_slot(from_index)
    var target_stack: ItemStack = inventory.get_slot(to_index)
    if source_stack == null or target_stack == null:
        return false
    if source_stack.is_empty() or target_stack.is_empty():
        return false
    if source_stack.item == null or target_stack.item == null:
        return false
    if source_stack.item.id != target_stack.item.id:
        return false

    var max_stack_size: int = source_stack.item.stack_size
    var room: int = max_stack_size - target_stack.amount
    if room <= 0:
        return false

    var transfer: int = min(room, source_stack.amount)
    source_stack.amount -= transfer
    target_stack.amount += transfer

    if source_stack.amount <= 0:
        inventory.set_slot(from_index, ItemStack.new())
    else:
        inventory.set_slot(from_index, source_stack)

    inventory.set_slot(to_index, target_stack)
    return true

func remove_item(index: int, amount: int = 1) -> int:
    if inventory == null:
        return 0
    return inventory.remove_item(index, amount)

func add_item(item: ItemData, amount: int = 1) -> int:
    if inventory == null:
        return 0
    return inventory.add_item(item, amount)
