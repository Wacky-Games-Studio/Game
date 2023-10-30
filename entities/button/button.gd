extends StaticBody2D

@export var door: Door

func _on_area_2d_body_entered(body):
	$Sprite2D.frame = 1
	$AudioStreamPlayer2D.play()
	door.open()
