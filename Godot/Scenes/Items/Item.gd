extends RigidBody
class_name Item

export (Texture) var icon: Texture;
export (String) var title: String = "Item title";
export (String) var description: String = "Item description";

# Get player node
onready var player = get_tree().get_nodes_in_group("Player")[0];

# When player enters collection area
func _on_CollectionArea_body_entered(body):
	# Play animations
	$Tween.interpolate_property(self, "global_transform:origin",
		global_transform.origin, body.global_transform.origin, 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT);
	$Tween.start();
	$Animator.play("Collect");

# When collect animations are finished
func _on_Tween_tween_completed(_object, _key):
	get_parent().remove_child(self);
	player.inventory.add(self);
