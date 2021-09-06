extends KinematicBody
class_name Item

export (Texture) var icon: Texture;
export (String) var title: String = "Item title";
export (String) var description: String = "Item description";
export (int) var item_id: int = -1;
export (int) var max_stack_size: int = 999;

var mesh = null;
var mesh_scale = 0.3;

# Gravity
var gravity: int = 20;
var velocity: Vector3 = Vector3.ZERO;

# Get player node
onready var player = get_tree().get_nodes_in_group("Player")[0];

func _ready():
	var mesh_instance = get_node("Origin/Mesh");
	mesh = mesh_instance.get_mesh();
	mesh_instance.set_scale(mesh_fixed_scale());

# Gravity
func _process(delta):
	velocity.y -= gravity * delta;
	velocity = move_and_slide(velocity, Vector3.UP);

func mesh_fixed_scale() -> Vector3:
	# Get new items mesh bounding box size
	var bb: Vector3 = mesh.get_aabb().size;
	# New scale from largest value in bb vector
	var ns = mesh_scale / max(bb.x, max(bb.y, bb.z));
	return Vector3(ns, ns, ns);

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
