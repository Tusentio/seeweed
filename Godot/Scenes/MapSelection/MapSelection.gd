extends Spatial

export (float) var speed: float = 25;

func _input(_event):
	var ray_length = 1000;
	var mouse_pos = get_viewport().get_mouse_position();
	var camera = get_viewport().get_camera();
	var from = camera.global_transform.origin;
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length;
	
	var space_state = get_world().get_direct_space_state();
	var result = space_state.intersect_ray(from, to, [], 0b1);
	
	# Move selection box to colliding object using tween
	if result:
		$Tween.interpolate_property(self, "global_transform:origin", 
		null, result.collider.global_transform.origin, 1 / speed, 
		Tween.TRANS_LINEAR, Tween.EASE_IN);
		$Tween.start();
