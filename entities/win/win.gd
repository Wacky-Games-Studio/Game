extends Area2D

func _on_body_entered(body) -> void:
	if body is Player:
		SceneManager.finnish_level()
