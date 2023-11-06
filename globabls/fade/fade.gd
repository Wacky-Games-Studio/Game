extends CanvasLayer

signal transitioned

func transition():
	$AnimationPlayer.play("fade_to_black")
	await get_tree().create_timer($AnimationPlayer.current_animation_length).timeout
	transitioned.emit()

func remove_transition():
	$AnimationPlayer.play("fade_to_normal")
	SceneManager.scene_paused = true
	
	await get_tree().create_timer($AnimationPlayer.current_animation_length).timeout
	SceneManager.scene_paused = false
