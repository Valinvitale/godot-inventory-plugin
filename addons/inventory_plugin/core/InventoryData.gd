class_name InventoryData
extends Resource

signal changed
signal slot_changed(index: int)

@export var inventory_name: String = "Inventory"
@export_range(1, 999, 1) var rows: int = 4
@export_range(1, 999, 1) var columns: int = 5
@export var slots: Array[ItemStack] = []

func _init(p_rows: int = 4, p_columns: int = 5) -> void:
    rows = max(1, p_rows)
    columns = max(1, p_columns)
    _ensure_slot_count()

func slot_count() -> int:
    return rows * columns

func is_valid_slot(index: int) -> bool:
    return index >= 0 and index < slots.size()

func resize(new_rows: int, new_columns: int) -> void:
    rows = max(1, new_rows)
    columns = max(1, new_columns)
    _ensure_slot_count()
    changed.emit()

func _ensure_slot_count() -> void:
    var target_count := slot_count()
    while slots.size() < target_count:
        slots.append(ItemStack.new())
    if slots.size() > target_count:
        slots.resize(target_count)

func get_slot(index: int) -> ItemStack:
    return slots[index] if is_valid_slot(index) else null

func set_slot(index: int, stack: ItemStack) -> bool:
    if not is_valid_slot(index):
        return false
    slots[index] = stack if stack != null else ItemStack.new()
    slot_changed.emit(index)
    changed.emit()
    return true

func clear_slot(index: int) -> bool:
    return set_slot(index, ItemStack.new())

func swap_slots(from_index: int, to_index: int) -> bool:
    if not is_valid_slot(from_index) or not is_valid_slot(to_index) or from_index == to_index:
        return false
    var temporary := slots[from_index]
    slots[from_index] = slots[to_index]
    slots[to_index] = temporary
    slot_changed.emit(from_index)
    slot_changed.emit(to_index)
    changed.emit()
    return true

func add_item(item: ItemData, amount: int = 1) -> int:
    if item == null or amount <= 0:
        return 0
    var remaining := amount
    for stack in slots:
        if stack != null and not stack.is_empty() and stack.item != null and stack.item.id == item.id:
            var transfer := min(remaining, max(0, stack.item.stack_size - stack.amount))
            stack.amount += transfer
            remaining -= transfer
            if remaining == 0:
                changed.emit()
                return amount
    for index in slots.size():
        var stack := slots[index]
        if stack == null or stack.is_empty():
            var transfer := min(remaining, item.stack_size)
            slots[index] = ItemStack.new(item, transfer)
            remaining -= transfer
            if remaining == 0:
                break
    changed.emit()
    return amount - remaining

func remove_item(index: int, amount_to_remove: int = 1) -> int:
    if not is_valid_slot(index) or amount_to_remove <= 0:
        return 0
    var stack := slots[index]
    if stack == null or stack.is_empty():
        return 0
    var removed := min(amount_to_remove, stack.amount)
    stack.amount -= removed
    if stack.amount <= 0:
        slots[index] = ItemStack.new()
    slot_changed.emit(index)
    changed.emit()
    return removed

func has_space_for(item: ItemData, amount: int = 1) -> bool:
    if item == null or amount <= 0:
        return false
    var remaining := amount
    for stack in slots:
        if stack != null and not stack.is_empty() and stack.item != null and stack.item.id == item.id:
            remaining -= min(remaining, max(0, stack.item.stack_size - stack.amount))
    for stack in slots:
        if stack == null or stack.is_empty():
            remaining -= min(remaining, item.stack_size)
        if remaining <= 0:
            return true
    return remaining <= 0

func clone() -> InventoryData:
    var copy := InventoryData.new(rows, columns)
    copy.inventory_name = inventory_name
    for index in slots.size():
        if slots[index] != null:
            copy.slots[index] = slots[index].clone()
    return copy
