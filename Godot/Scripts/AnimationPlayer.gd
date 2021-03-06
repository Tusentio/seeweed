extends AnimationPlayer

# Reset AnimationPlayer and play requested animation
func reset_and_play(anim_name, force_reset = false):
	if current_animation != anim_name or force_reset:
		if is_playing():
			seek(0, true);
		play(anim_name);
