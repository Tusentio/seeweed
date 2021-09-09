extends Block

func on_tile_created(tile: Tile):
	tile.mesh_instance.rotate_object_local(Vector3.UP,
			deg2rad(90 * (randi() % 4)));
	
	tile.mesh_instance.transform.origin += Vector3(int(rand_range(-3, 3)), 0,
			int(rand_range(-3, 3))) + Vector3.ONE * 0.1;
