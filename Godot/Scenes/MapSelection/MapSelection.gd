extends Spatial

export (float) var speed: float = 25;
export (float) var max_player_distance: float = 3;
onready var player: Player = get_tree().get_nodes_in_group("Player")[0];

const RAY_LENGTH := 1000;
const EPSILON := 0.01;

func _process(_delta):
	# Create ray
	var mouse_pos := get_viewport().get_mouse_position();
	var camera := get_viewport().get_camera();
	var from := camera.global_transform.origin;
	var to := from + camera.project_ray_normal(mouse_pos) * RAY_LENGTH;
	var ray_normal := (to - from).normalized();
	
	var space_state := get_world().get_direct_space_state();
	var result := space_state.intersect_ray(from, to, [], 0b1000);
	
	# If ray didn't hit anything
	if not result:
		visible = false;
		return;
	
	var position: Vector3 = result.position + ray_normal * EPSILON;
	var tile_position := position.floor();
	var center_position = tile_position + Vector3.ONE / 2;
	
	# If hit position and player are too far apart
	if center_position.distance_to(player.global_transform.origin) > max_player_distance:
		visible = false;
		return;
	
	# Move selection box to colliding tile and reset animation
	if global_transform.origin != tile_position:
		$Animator.seek(0, true);
		global_transform.origin = tile_position;
	visible = true;

# Get cursor position
func pos() -> Vector3:
	return global_transform.origin.round();
