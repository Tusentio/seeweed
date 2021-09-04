extends VBoxContainer

# Get player
onready var player: Player = get_tree().get_nodes_in_group("Player")[0];

# Default slot name and description
var empty_slot_name = "Empty Slot"
var empty_slot_desc = "Used to store items."

# Connect signals from inventory and player
func _ready():
	player.inventory.connect("inventory_update", self, "update_text");
	player.connect("slot_change", self, "update_text");
	
func update_text(updated_slot):
	if updated_slot == player.selected_slot:
		# Get selected item
		var item = player.inventory.get_at(updated_slot);
		
		# Update name and description
		$ItemName.text = item.item_name if item else empty_slot_name;
		$ItemDesc.text = item.item_description if item else empty_slot_desc;
