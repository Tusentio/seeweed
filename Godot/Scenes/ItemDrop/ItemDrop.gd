extends KinematicBody

export (Resource) var item;

var velocity: Vector3 = Vector3.ZERO;
var player: Player;

const GRAVITY: float = 20.0;

func _ready():
	$Body/Mesh.set_mesh(item.mesh);
	$Body/Mesh.set_scale(item.calc_drop_scale());

func _process(delta):
	velocity.y -= GRAVITY * item.weight * delta;
	velocity = move_and_slide(velocity, Vector3.UP);

# When player enters collection area
func _on_CollectionArea_body_entered(body):
	if body is Player:
		player = body;
		
		# Play animations
		$Animator.play("Collect");
		$Tween.interpolate_property(self, "global_transform:origin",
			global_transform.origin, player.global_transform.origin, 0.2,
			Tween.TRANS_LINEAR, Tween.EASE_IN);
		$Tween.start();

# When collect animations are finished
func _on_Tween_tween_completed(_object, _key):
	player.inventory.add(item);
	queue_free();
