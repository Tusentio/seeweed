extends Node

# When items gets added or removed
signal inventory_update
class_name Inventory

export (int) var slots: int;

var store: Array = [];

# Constructor
func _init(size = 5):
	slots = size;
	store.resize(slots);

func has(item: Item) -> bool:
	return store.has(item);

func add(item: Item) -> void:
	# Make sure inventory isn't full
	if has(null) and is_instance_valid(item):
		var slot = store.find(null);
		store[slot] = item;
		emit_signal("inventory_update", slot);

# Remove item from inventory and return it
func remove(item: Item) -> Item:
	var slot: int = store.find(item);
	if slot:
		store[slot] = null;
		emit_signal("inventory_update", slot);
	return item;

# Get item from slot index
func get_at(slot: int) -> Item:
	return store[slot];
