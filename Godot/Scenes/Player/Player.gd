extends KinematicBody
class_name Player

signal slot_change;

# Movement vars
export (int) var speed: int = 4;
export (int) var gravity: int = 20;
export (float) var turn_speed: float = 40.0;
var velocity: Vector3 = Vector3.ZERO;
var _looking_at: Vector3 = Vector3.ZERO;

# Inventory vars
var inventory = preload("res://Scripts/Inventory.gd").new();
var selected_slot: int = 0;

func select_slot(slot):
	selected_slot = abs(inventory.slots + slot) % inventory.slots;
	emit_signal("slot_change", selected_slot);

func _input(event):
	# Change selected slot
	if event is InputEventMouseButton and event.is_pressed():
		match(event.button_index):
			BUTTON_WHEEL_UP:
				select_slot(selected_slot - 1);
			BUTTON_WHEEL_DOWN:
				select_slot(selected_slot + 1);

# Movement code
func _physics_process(delta):
	velocity.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left");
	velocity.z = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward");
	
	if velocity.x or velocity.z:
		_looking_at = velocity.normalized();
		
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

# Smoothly rotate player
func _process(delta):	
	if not _looking_at or not delta:
		return;

	var weight = pow(1 - 1 / turn_speed, 1 / delta);
	var look_target = global_transform.origin + _looking_at * Vector3(1, 0, 1);
	var rotated_transform = global_transform.looking_at(look_target, Vector3.UP);
	$Body.transform.basis = $Body.transform.basis.slerp(rotated_transform.basis, weight);
