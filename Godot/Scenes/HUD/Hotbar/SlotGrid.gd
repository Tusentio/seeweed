extends GridContainer

# Get player node and slot scene
onready var player: Player = get_tree().get_nodes_in_group("Player")[0];
const slot = preload("res://Scenes/HUD/Slot/Slot.tscn");

var current_slot_node = null;

var selected_bg_alpha = 0.75;
var default_bg_alpha = slot.instance().color.a;

func _ready():
	player.connect("slot_change", self, "_on_slot_change");
	
	# Generate slots and bind them to player inventory
	for i in range(player.inventory.slots):
		var slot_child = slot.instance();
		slot_child.bind(player.inventory, i);
		add_child(slot_child);
	
	player.select_slot(0);

func _on_slot_change(slot_index):
	# Reset bg alpha of current slot
	if current_slot_node:
		current_slot_node.color.a = default_bg_alpha;
	
	# Get child with same index as slot and set bg alpha
	current_slot_node = get_child(slot_index);
	current_slot_node.color.a = selected_bg_alpha;
	current_slot_node.wobble();
