extends KinematicBody

export (int) var speed: int = 4;
export (int) var max_health;
var health = max_health;

# Reset AnimationPlayer and play requested animation
func play_animation(anim_name):
	if $Animator.current_animation != anim_name:
		$Animator.seek(0, true);
		$Animator.play(anim_name);
