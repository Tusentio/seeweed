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
		# Set slot image
		var item = inventory.get_item_at(bound_slot);
		$ItemPreview.set_texture(item.icon if item else null);
		
		# Set count label text and visibility
		var count = inventory.get_count_at(bound_slot);
		$StackCount.visible = count != 1;
		$StackCount.text = String(count);
		
		wobble();
	
# Play wobble animation on slot rect
func wobble():
	$Animator.play("Wobble");
