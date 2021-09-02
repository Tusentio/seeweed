extends KinematicBody

export (int) var speed = 4;
export (int) var gravity = 20;
export (float) var turn_speed = 40.0;

var velocity = Vector3.ZERO;
var look_target : Spatial = null;

var _looking_at = Vector3.ZERO;

func _physics_process(delta):
	velocity.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left");
	velocity.z = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward");
	
	if velocity:
		_looking_at = global_transform.origin + velocity * Vector3(1, 0, 1);
		
		# Reset animation
		if ($Animator.current_animation == "idle"):
			$Animator.seek(0, true);
			
		$Animator.play("walk");
	else:
		# Reset animation and play idle
		if ($Animator.current_animation == "walk"):
			$Animator.seek(0, true);
			$Animator.play("idle");
	
	velocity.y -= gravity * delta;
	
	velocity = move_and_slide(velocity.normalized() * speed, Vector3.UP);
	
func _process(delta):
	if not _looking_at or not delta:
		return;

	if look_target:
		_looking_at = look_target.global_transform.origin;

	var weight = pow(1 - 1 / turn_speed, 1 / delta);
	var rotated_transform = global_transform.looking_at(_looking_at, Vector3.UP);
	$Body.transform.basis = $Body.transform.basis.slerp(rotated_transform.basis, weight);