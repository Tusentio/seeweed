extends KinematicBody

export (Resource) var item;
export (int) var size: int = 1;

var velocity: Vector3 = Vector3.ZERO;
var friction: float = 7.0;
var player: Player;
var _sync_index: int = rand_range(0x0, 0xffffffff);

const RANDOM_PITCH_FACTOR := 0.9;
const GRAVITY: float = 50.0;

func _ready():
	$Content/Body/Mesh.set_mesh(item.mesh);
	$Content/Body/Mesh.set_scale(item.calc_drop_scale());

func init(item: Item, position: Vector3, velocity: Vector3 = Vector3.ZERO):
	self.item = item;
	self.velocity = velocity;
	transform.origin = position;
	return self;

func _process(delta):
	velocity *= pow(2, -friction * delta);
	velocity.y -= GRAVITY * item.weight * delta;
	velocity = move_and_slide(velocity, Vector3.UP);

# When player enters collection area
func _on_CollectionArea_body_entered(body):
	if body is Player and can_be_collected():
		player = body;
		
		$Collect.pitch_scale = rand_range(RANDOM_PITCH_FACTOR,
				1 / RANDOM_PITCH_FACTOR);
		$Collect.play();
		
		# Play animations
		$Animator.play("Collect");
		$Tween.interpolate_property(self, "global_transform:origin",
			global_transform.origin, player.global_transform.origin, 0.2,
			Tween.TRANS_LINEAR, Tween.EASE_IN);
		$Tween.start();

func _on_MergeArea_body_entered(body):
	if body is get_script():
		var other_drop = body;
		var synced = other_drop._sync_index == _sync_index;
		if not synced and other_drop.item == item:
			_sync_index = other_drop._sync_index;
			other_drop.size += size;
			queue_free();

# When collect animations are finished
func _on_Tween_tween_completed(_object, _key):
	player.inventory.add(item, size);
	$Content.queue_free();

# Wait for collect sound to end before queue-freeing
func _on_Collect_finished():
	queue_free();

func can_be_collected() -> bool:
	return $CollectCooldown.is_stopped();
