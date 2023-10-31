extends CanvasLayer

signal transitioned

func transition():
	$AnimationPlayer.play("fade_to_black")
	await get_tree().create_timer($AnimationPlayer.current_animation_length).timeout
	transitioned.emit()

func remove_transition():
	$AnimationPlayer.play("fade_to_normal")
	GlobalState.pause_process()
	await get_tree().create_timer($AnimationPlayer.current_animation_length).timeout
	GlobalState.start_process()
