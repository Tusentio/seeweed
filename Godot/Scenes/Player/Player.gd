extends KinematicBody

export (int) var speed = 4;
export (int) var gravity = 20;

var velocity = Vector3.ZERO;

func _physics_process(delta):

	velocity.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left");
	velocity.z = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward");
	
	if velocity != Vector3.ZERO:
		$Body.look_at(translation + velocity, Vector3.UP);
	
	velocity.y -= gravity * delta;
	
	velocity = move_and_slide(velocity.normalized() * speed, Vector3.UP);
