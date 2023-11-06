extends Node2D

func _on_area_entered(body):
	if body is Player:
		body.global_position = $Marker2D.global_position
