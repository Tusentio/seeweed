extends "res://Scripts/Character.gd"
class_name Player

signal slot_change;

# Movement vars
export (int) var gravity: int = 20;
export (float) var turn_speed: float = 10.0;
export (float) var item_throw_speed = 5;
var velocity: Vector3 = Vector3.ZERO;
var _looking_at: Vector3 = Vector3.ZERO;

# Inventory vars
var inventory = preload("res://Scripts/Inventory.gd").new();
var selected_slot: int = 0;

var item_drop = load("res://Scenes/ItemDrop/ItemDrop.tscn");

func select_slot(slot):
	selected_slot = abs(inventory.slots + slot) % inventory.slots;
	emit_signal("slot_change", selected_slot);

func _input(_event):
	var prev_slot = selected_slot;
	
	# Drop item
	if Input.is_action_just_pressed("drop_held_item"):
		var item_to_drop = inventory.get_item_at(selected_slot);
		if item_to_drop:
			# Remove item from inventory and create new ItemDrop instance
			inventory.remove_at(selected_slot, 1);
			var new_drop = item_drop.instance();
			new_drop.init(item_to_drop, global_transform.origin, _looking_at * item_throw_speed);
			get_tree().get_root().add_child(new_drop);
	
	# Change selected slot when scrolling or pressing arrow keys
	if Input.is_action_pressed("hotbar_next"):
		select_slot(selected_slot + 1);
	elif Input.is_action_pressed("hotbar_prev"):
		select_slot(selected_slot - 1);
	
	# Hotbar item quick swap
	if Input.is_action_pressed("hotbar_swap"):
		if selected_slot != prev_slot:
			inventory.swap(prev_slot, selected_slot);

# Movement code
func _physics_process(delta):
	velocity.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left");
	velocity.z = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward");
	
	if velocity.x or velocity.z:
		_looking_at = velocity.normalized();
		play_animation("walk");
	else:
		play_animation("idle");
	
	velocity.y -= gravity * delta;
	velocity = move_and_slide(velocity.normalized() * speed, Vector3.UP);

# Smoothly rotate player
func _process(delta):
	if not _looking_at or delta <= 0:
		return;

	var weight = 1 - pow(1 / turn_speed, delta * 10);
	var look_target = global_transform.origin + _looking_at * Vector3(1, 0, 1);
	var rotated_transform = global_transform.looking_at(look_target, Vector3.UP);
	$Body.transform.basis = $Body.transform.basis.slerp(rotated_transform.basis, weight);
