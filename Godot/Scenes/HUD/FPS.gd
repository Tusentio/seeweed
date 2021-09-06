extends Label

func _process(_delta):
	text = String(Engine.get_frames_per_second()) + " FPS";
