extends Block

func on_tile_created(tile: Tile):
	if randf() > 0.5:
		tile.mesh_instance.rotate_object_local(Vector3.UP, deg2rad(180));
