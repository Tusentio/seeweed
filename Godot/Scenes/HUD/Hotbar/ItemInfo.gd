extends VBoxContainer

# Get player
onready var player: Player = get_tree().get_nodes_in_group("Player")[0];

# Default slot name and description
var empty_slot_name = "Empty Slot"
var empty_slot_desc = "Used to store items."

# Connect signals from inventory and player
func _ready():
	player.inventory.connect("inventory_update", self, "_on_inventory_update");
	player.connect("slot_change", self, "_on_slot_change");
	
func _on_inventory_update(slot, _delta):
	update_info(slot);

func _on_slot_change(slot):
	update_info(slot);

# Updating title and description text when inventory gets updated
func update_info(slot):
	if slot == player.selected_slot:
		# Get selected item
		var item = player.inventory.get_item_at(slot);
		
		# Update title and description UI text
		$ItemTitle.text = item.title if item else empty_slot_name;
		$ItemDesc.text = item.description if item else empty_slot_desc;
