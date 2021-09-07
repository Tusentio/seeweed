extends Node
class_name Inventory

# When items gets added or removed
signal inventory_update

export (int) var slots: int;

var _store: Array = [];
var _counts: Array = [];

# Constructor
func _init(size = 5):
	resize(size);

func resize(size):
	slots = size;
	_store.resize(size);
	_counts.resize(size);

func has(item: Item) -> bool:
	return _store.has(item);

func add(item: Item, count: int = 1) -> int:
	if count <= 0 or not is_instance_valid(item):
		return 0;
	
	# Find an available slot for this item
	var slot: int = find_slot_of(item, 0);
	
	# Make sure the slot is not maxed out
	while slot >= 0 and get_count_at(slot) >= item.max_stack_size:
		slot = find_slot_of(item, slot + 1); # Find next slot with item
	
	if slot < 0: # No available slot with this item
		slot = find_slot_of(null, 0);
		if slot < 0:
			return 0;
	
	return add_at(slot, item, count);

func add_at(slot: int, item: Item, count: int = 1) -> int:
	if count <= 0 or not is_instance_valid(item):
		return 0;
	
	if not get_item_at(slot):
		_store[slot] = item;
	
	var old_count: int = get_count_at(slot);
	var free: int = get_free_at(slot, item);
	
	_counts[slot] = old_count + count;
	var added_count: int = count + add(item, count - free); # Add remainder (if any)
	
	emit_signal("inventory_update", slot, added_count);
	return added_count;

# Try removing item(s) from inventory and return how many that could be removed
func remove(item: Item, count: int = 1) -> int:
	if count <= 0 or not is_instance_valid(item):
		return 0;
	
	# Find a slot with this item
	var slot: int = find_slot_of(item, 0);
	if slot < 0:
		return 0;
	
	return remove_at(slot, count);

func remove_at(slot: int, count: int = 1) -> int:
	if count <= 0:
		return 0;
	
	var item: Item = get_item_at(slot);
	var available: int = get_count_at(slot);
	if not item or not available:
		return 0;
	
	var removed_count: int;
	
	# Remove as many as possible
	if count >= available:
		_store[slot] = null;
		_counts[slot] = null;
		removed_count = available + remove(item, count - available); # Remove remainder (if any)
	else:
		_counts[slot] = available - count;
		removed_count = count;
	
	emit_signal("inventory_update", slot, -removed_count);
	return removed_count;

# Get item from slot index
func get_item_at(slot: int) -> Item:
	return _store[slot];

# Get count from slot index
func get_count_at(slot: int) -> int:
	return _counts[slot] if _counts[slot] else 0;

func get_free_at(slot: int, item: Item) -> int:
	if not is_instance_valid(item):
		return 0;
	
	var slot_item: Item = get_item_at(slot);
	if slot_item and slot_item.item_id != item.item_id:
		return 0;
	
	var free: int = item.max_stack_size - get_count_at(slot);
	return free if free >= 0 else 0;

# Get total count of an item in the inventory
func get_count_of(item: Item) -> int:
	var count: int = 0;
	var slot: int = find_slot_of(item, 0);
	while slot >= 0:
		count = count + _counts[slot];
		slot = find_slot_of(item, slot + 1);
	return count;

func find_slot_of(item: Item, from: int = 0):
	return _store.find(item, from);

func move(from: int, to: int, count: int = 1) -> int:
	var item: Item = get_item_at(from);
	var available: int = get_count_at(from);
	var free: int = get_free_at(to, item);
	
	count = clamp(count, 0, min(free, available));
	if count <= 0:
		return 0;
	
	add_at(to, item, remove_at(from, count));
	return count;

func swap(first: int, second: int):
	var temp_count = _counts[first];
	_counts[first] = _counts[second];
	_counts[second] = temp_count;
	
	var temp_item = _store[first];
	_store[first] = _store[second];
	_store[second] = temp_item;
	
	var delta = get_count_at(first) - get_count_at(second);
	if delta != 0:
		emit_signal("inventory_update", first, delta);
		emit_signal("inventory_update", second, -delta);
