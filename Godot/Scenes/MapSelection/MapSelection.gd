extends Spatial

export (float) var speed: float = 25;
export (float) var max_distance: float = 5;
onready var player: Player = get_tree().get_nodes_in_group("Player")[0];

func _physics_process(_delta):
	# Creat ray
	var ray_length = 1000;
	var mouse_pos = get_viewport().get_mouse_position();
	var camera = get_viewport().get_camera();
	var from = camera.global_transform.origin;
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length;
	
	var space_state = get_world().get_direct_space_state();
	var result = space_state.intersect_ray(from, to, [], 0b1);
	
	# If ray didn't hit anything
	if not result:
		visible = false;
		return;
	
	# Get hit object position
	var result_pos = result.collider.global_transform.origin;
	
	# If object and player are too far apart
	if result_pos.distance_to(player.global_transform.origin) > max_distance:
		visible = false;
		return;
	
	# Move selection box to colliding object using tween
	visible = true;
	global_transform.origin = result_pos;
		
# Get cursor position
func pos() -> Vector3:
	return global_transform.origin.round();
