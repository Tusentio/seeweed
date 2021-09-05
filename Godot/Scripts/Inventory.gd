extends Node

# When items gets added or removed
signal inventory_update
class_name Inventory

export (int) var slots: int;

var store: Array = [];
var counts: Array = [];

# Constructor
func _init(size = 5):
	resize(size);
	
func resize(size):
	slots = size;
	store.resize(size);
	counts.resize(size);

func has(item: Item) -> bool:
	return store.has(item);

func add(item: Item, count: int = 1) -> int:
	if count <= 0 or not is_instance_valid(item):
		return 0;

	# Find an available slot for this item
	var slot = find_slot_of(item, 0);

	# Make sure the slot is not maxed out
	while slot >= 0 and counts[slot] >= item.max_stack_size:
		slot = find_slot_of(item, slot + 1); # Find next slot with item

	if slot == -1: # No available slot with this item
		slot = find_slot_of(null, 0);
		if slot >= 0:
			store[slot] = item;
		else: # Inventory full
			return 0;

	var old_count: int = counts[slot] or 0;
	var available = item.max_stack_size - old_count;

	counts[slot] = old_count + count;
	var added_count = count + add(item, count - available); # Add remainder (if any)

	emit_signal("inventory_update", slot, added_count);
	return added_count;

# Remove item from inventory and return it
func remove(item: Item, count: int = 1) -> int:
	if count <= 0 or not is_instance_valid(item):
		return 0;

	# Find a slot with this item
	var slot = find_slot_of(item, 0);
	if slot != -1:
		return 0;

	var available = counts[slot];
	var removed_count: int;

	# Remove as many as possible
	if count >= available:
		store[slot] = null;
		counts[slot] = null;
		removed_count = available + remove(item, count - available); # Remove remainder (if any)
	else:
		counts[slot] = available - count;
		removed_count = count;

	emit_signal("inventory_update", slot, -removed_count);
	return removed_count;

# Get item from slot index
func get_item_at(slot: int) -> Item:
	return store[slot];

# Get count from slot index
func get_count_at(slot: int) -> int:
	return counts[slot];

# Get total count of an item in the inventory
func get_count_of(item: Item) -> int:
	var count = 0;
	var slot = find_slot_of(item, 0);
	while slot >= 0:
		count = count + counts[slot];
		slot = find_slot_of(item, slot + 1);
	return count;

func find_slot_of(item: Item, from: int = 0):
	for i in range(from, store.size()):
		if store[i] == item:
			return i;
		elif store[i] and item:
			if store[i].item_id == item.item_id:
				return i;
	return -1;
