extends State

func enter() -> void:
	super()
	
	if not parent.fake_dead:
		await parent.animator.animation_finished
		SceneManager.restart_level()
