extends KinematicBody

export (Resource) var item;
export (int) var size: int = 1;

var velocity: Vector3 = Vector3.ZERO;
var friction = 0.85;
var player: Player;

const GRAVITY: float = 20.0;

func _ready():
	$Body/Mesh.set_mesh(item.mesh);
	$Body/Mesh.set_scale(item.calc_drop_scale());

func init(item: Item, position: Vector3, velocity: Vector3 = Vector3.ZERO):
	self.item = item;
	self.velocity = velocity;
	global_transform.origin = position;
	return self;

func _process(delta):
	velocity *= pow(1 / friction, delta);
	velocity.y -= GRAVITY * item.weight * delta;
	velocity = move_and_slide(velocity, Vector3.UP);

# When player enters collection area
func _on_CollectionArea_body_entered(body):
	if body is Player and can_be_collected():
		player = body;
		
		# Play animations
		$Animator.play("Collect");
		$Tween.interpolate_property(self, "global_transform:origin",
			global_transform.origin, player.global_transform.origin, 0.2,
			Tween.TRANS_LINEAR, Tween.EASE_IN);
		$Tween.start();

# When collect animations are finished
func _on_Tween_tween_completed(_object, _key):
	player.inventory.add(item, size);
	queue_free();

func can_be_collected() -> bool:
	return $CollectCooldown.is_stopped();