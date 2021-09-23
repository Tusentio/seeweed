extends "res://Scripts/Character.gd"
class_name Player

signal slot_change;

# Movement vars
export (float) var gravity := 20.0;
export (float) var turn_speed := 10.0;
export (float) var item_throw_speed := 10.0;
export (bool) var drift_mode := false;
var velocity: Vector3 = Vector3.ZERO;
var _looking_at: Vector3 = Vector3.ZERO;

# Inventory vars
var inventory: Inventory = preload("res://Scripts/Inventory.gd").new();
var selected_slot: int = 0;

var item_drop = load("res://Scenes/ItemDrop/ItemDrop.tscn");

# Map selection
onready var map_selection = get_tree().get_nodes_in_group("Cursor")[0];

func select_slot(slot):
	selected_slot = int(abs(inventory.slots + slot)) % inventory.slots;
	emit_signal("slot_change", selected_slot);

func _input(_event):
	var prev_slot = selected_slot;
	
	# Use held item
	if Input.is_action_just_pressed("use_item"):
		var item_to_use = inventory.get_item_at(selected_slot);
		if item_to_use and map_selection.visible:
			$ActionAnimations.reset_and_play("use");
			item_to_use.on_item_use(self, map_selection.pos(), selected_slot);
	
	# Drop item
	if Input.is_action_just_pressed("drop_held_item"):
		var item_to_drop = inventory.get_item_at(selected_slot);
		if item_to_drop:
			# Remove item from inventory and create new ItemDrop instance
			inventory.remove_at(selected_slot, 1);
			var new_drop = item_drop.instance();
			new_drop.init(item_to_drop, global_transform.origin, velocity +
					_looking_at * item_throw_speed);
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
	var input_velocity := Vector3.ZERO;
	input_velocity.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left");
	input_velocity.z = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward");
	
	if input_velocity.x or input_velocity.z:
		_looking_at = input_velocity.normalized();
		$WalkAnimations.reset_and_play("walk");
	else:
		$WalkAnimations.reset_and_play("idle");
	
	velocity.y -= gravity * delta;
	
	if drift_mode:
		# Drift Mode
		velocity = move_and_slide(velocity + input_velocity.normalized() *
				speed * delta, Vector3.UP);
	else:
		# Normal
		velocity = move_and_slide(velocity * Vector3.UP +
				input_velocity.normalized() * speed, Vector3.UP);

# Smoothly rotate player
func _process(delta):
	if not _looking_at or delta <= 0:
		return;

	var weight = 1 - pow(1 / turn_speed, delta * 10);
	var look_target = global_transform.origin + _looking_at * Vector3(1, 0, 1);
	var rotated_transform = global_transform.looking_at(look_target, Vector3.UP);
	$Body.transform.basis = $Body.transform.basis.slerp(rotated_transform.basis, weight);
