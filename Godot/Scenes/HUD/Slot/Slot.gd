extends TextureRect

var inventory: Inventory = null;
var bound_slot: int = 0;

# Bind this slot to inventory slot
func bind(inv: Inventory, slot: int = get_index()):
	inventory = inv;
	bound_slot = slot;
	#warning-ignore:return_value_discarded
	inventory.connect("inventory_update", self, "_on_inventory_update");

# When any inventory slot gets updated
func _on_inventory_update(slot, _delta):
	if slot == bound_slot:
		var item = inventory.get_item_at(bound_slot);
		$ItemPreview.set_texture(item.icon if item else null);
		wobble();
	
# Play wobble animation on slot rect
func wobble():
	$Animator.play("Wobble");
