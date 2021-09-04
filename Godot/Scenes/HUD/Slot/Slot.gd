extends ColorRect

func _ready():
	pass;

func wobble():
	$Animator.play("Wobble");
