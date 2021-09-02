extends KinematicBody

export (int) var speed = 4;
export (int) var gravity = 20;

var velocity = Vector3.ZERO;

func _physics_process(delta):

	velocity.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left");
	velocity.z = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward");
	
	if velocity.x || velocity.z:
		# Reset animation
		if ($Animator.current_animation == "idle"):
			$Animator.seek(0, true);
			
		$Animator.play("walk");
		$Body.look_at(translation + velocity, Vector3.UP);
	else:
		# Reset animation and play idle
		if ($Animator.current_animation == "walk"):
			$Animator.seek(0, true);
			$Animator.play("idle");
	
	velocity.y -= gravity * delta;
	
	velocity = move_and_slide(velocity.normalized() * speed, Vector3.UP);
