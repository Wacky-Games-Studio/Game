extends CanvasLayer

signal transitioned
signal transitioned_out

@export var transitions_in: Array[Texture2D]
@export var transitions_out: Array[Texture2D]

var current_random := 0

func change_sprite(transition_in: bool = true) -> void:
	if transition_in:
		var tex = transitions_in.pick_random()
		current_random = transitions_in.find(tex, 0)
		$TextureRect.texture = tex
	else:
		$TextureRect.texture = transitions_out[current_random]
	

func transition() -> void:
	SceneManager.scene_paused = true
	
	$AnimationPlayer.play("fade_to_black")

	await get_tree().create_timer($AnimationPlayer.current_animation_length).timeout
	transitioned.emit()
	SceneManager.scene_paused = false
	

func remove_transition() -> void:
	SceneManager.scene_paused = true
	$AnimationPlayer.play("fade_to_normal")
	
	await get_tree().create_timer($AnimationPlayer.current_animation_length).timeout
	transitioned_out.emit()
	SceneManager.scene_paused = false
