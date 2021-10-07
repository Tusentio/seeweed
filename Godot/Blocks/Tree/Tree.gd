extends Block

func on_destroy(position: Vector3, terrain: Object, sender: Object):
	terrain.get_tree().quit();
