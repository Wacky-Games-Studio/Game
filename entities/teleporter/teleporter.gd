extends Node2D

func _on_area_entered(body) -> void:
	if body is Player:
		body.global_position = $Marker2D.global_position