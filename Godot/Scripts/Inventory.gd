extends Node

# When items gets added or removed
signal inventory_update

export (int) var slots: int = 0;

var store: Array = [];

# Constructor
func _init(size = 5):
	slots = size;
	store.resize(slots);
	
func has(item: Storable) -> bool:
	return store.has(item);

func add(item: Storable) -> void:
	if has(null) and item:
		var slot = store.find(null);
		store[slot] = item;
		emit_signal("inventory_update", slot);

func remove(item: Storable) -> void:
	var slot: int = store.find(item);
	if slot:
		store[slot] = null;
		emit_signal("inventory_update", slot);
		
func get_at(slot: int) -> Storable:
	return store[slot];
