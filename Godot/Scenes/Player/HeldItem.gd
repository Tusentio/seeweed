extends MeshInstance

# Get player
onready var player: Player = get_tree().get_nodes_in_group("Player")[0];

# Connect signals from player and inventory
func _ready():
	player.inventory.connect("inventory_update", self, "_on_inventory_update");
	player.connect("slot_change", self, "_on_slot_change");

func _on_inventory_update(_slot, _delta):
	update_mesh();

func _on_slot_change(_slot):
	update_mesh();

# When items gets added and removed from inventory and when user changes slot
func update_mesh():
	# Remove currently holding item
	set_mesh(null);

	# Add new item to hand
	var new_item = player.inventory.get_item_at(player.selected_slot);
	if new_item:
		set_mesh(new_item.mesh);
