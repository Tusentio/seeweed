extends ColorRect

var inventory: Inventory = null;
var bound_slot: int = 0;

# Bind this slot to inventory slot
func bind(inv: Inventory, slot: int = get_index()):
	inventory = inv;
	bound_slot = slot;
	inventory.connect("inventory_update", self, "slot_update");

# When any inventory slot gets updated
func slot_update(updated_slot):
	if updated_slot == bound_slot:
		var item = inventory.get_at(bound_slot);
		$ItemPreview.set_texture(item.icon if item else null);
		wobble();
	
# Play wobble animation on slot rect
func wobble():
	$Animator.play("Wobble");