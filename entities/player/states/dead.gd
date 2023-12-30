extends State

func enter() -> void:
	super()
	
	await parent.animator.animation_finished
	SceneManager.restart_level()
