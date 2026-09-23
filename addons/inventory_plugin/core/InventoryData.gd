class_name InventoryData
extends Resource

signal changed

@export var inventory_name: String = "Inventory"
@export var rows: int = 4
@export var columns: int = 5
@export var slots: Array[ItemStack] = []

func _init(p_rows: int = 4, p_columns: int = 5) -> void:
    resize(p_rows, p_columns)

func slot_count() -> int:
    return rows * columns

func is_valid_slot(index: int) -> bool:
    return index >= 0 and index < slots.size()

func resize(new_rows: int, new_columns: int) -> void:
    rows = max(1, new_rows)
    columns = max(1, new_columns)

    var target_count: int = rows * columns
    if slots.size() < target_count:
        for i in range(slots.size(), target_count):
            slots.append(ItemStack.new())
    elif slots.size() > target_count:
        slots.resize(target_count)

    emit_signal("changed")

func get_slot(index: int) -> ItemStack:
    if not is_valid_slot(index):
        return null
    return slots[index]

func set_slot(index: int, stack: ItemStack) -> void:
    if not is_valid_slot(index):
        return

    if stack == null:
        slots[index] = ItemStack.new()
    else:
        slots[index] = stack

    emit_signal("changed")

func clear_slot(index: int) -> void:
    if not is_valid_slot(index):
        return
    slots[index] = ItemStack.new()
    emit_signal("changed")

func swap_slots(from_index: int, to_index: int) -> void:
    if not is_valid_slot(from_index) or not is_valid_slot(to_index):
        return
    if from_index == to_index:
        return

    var temp: ItemStack = slots[from_index]
    slots[from_index] = slots[to_index]
    slots[to_index] = temp
    emit_signal("changed")

func add_item(item: ItemData, amount: int = 1) -> int:
    if item == null:
        return 0
    if amount <= 0:
        return 0

    var remaining: int = amount

    for i in range(slots.size()):
        var current: ItemStack = slots[i]
        if current == null or current.is_empty():
            continue
        if current.item == null:
            continue
        if current.item.id == item.id and current.amount < current.item.stack_size:
            var free_space: int = current.item.stack_size - current.amount
            var to_add: int = min(remaining, free_space)
            current.amount += to_add
            remaining -= to_add
            if remaining == 0:
                emit_signal("changed")
                return amount

    if remaining > 0:
        for i in range(slots.size()):
            var current: ItemStack = slots[i]
            if current == null or current.is_empty():
                var to_add: int = min(remaining, item.stack_size)
                slots[i] = ItemStack.new(item, to_add)
                remaining -= to_add
                if remaining == 0:
                    break

    emit_signal("changed")
    return amount - remaining

func remove_item(index: int, amount_to_remove: int = 1) -> int:
    if not is_valid_slot(index):
        return 0

    var stack: ItemStack = slots[index]
    if stack == null or stack.is_empty():
        return 0

    var removed: int = min(amount_to_remove, stack.amount)
    stack.amount -= removed
    if stack.amount <= 0:
        slots[index] = ItemStack.new()

    emit_signal("changed")
    return removed

func has_space_for(item: ItemData, amount: int = 1) -> bool:
    if item == null or amount <= 0:
        return false

    var needed: int = amount
    for stack: ItemStack in slots:
        if stack != null and not stack.is_empty() and stack.item != null and stack.item.id == item.id:
            needed -= max(0, min(needed, stack.item.stack_size - stack.amount))
            if needed <= 0:
                return true

    for stack: ItemStack in slots:
        if stack == null or stack.is_empty():
            needed -= min(needed, item.stack_size)
            if needed <= 0:
                return true

    return false

func clone() -> InventoryData:
    var copy := InventoryData.new(rows, columns)
    copy.inventory_name = inventory_name
    for i in range(slots.size()):
        var stack: ItemStack = slots[i]
        if stack == null or stack.is_empty():
            continue
        copy.slots[i] = stack.clone()
    return copy
