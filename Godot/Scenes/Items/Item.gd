extends KinematicBody
class_name Item

export (int) var item_id: int = -1;
export (Texture) var icon: Texture;
export (String) var title: String = "Item title";
export (String) var description: String = "Item description";
export (int) var gravity: int = 20;
export (int) var max_stack_size: int = 999;

onready var mesh = get_node("Origin/Mesh").get_mesh();
var velocity: Vector3 = Vector3.ZERO;

# Get player node
onready var player = get_tree().get_nodes_in_group("Player")[0];

# Gravity
func _process(delta):
	velocity.y -= gravity * delta;
	velocity = move_and_slide(velocity, Vector3.UP);

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
	# Reset position back to center
	global_transform.origin = Vector3(0,0,0);
	
	get_parent().remove_child(self);
	
	# Reset animation. Making the item visible again
	$Animator.seek(0, true);
	
	player.inventory.add(self);
