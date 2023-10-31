extends Area2D

var dir = Vector2.UP

func _ready():
	var angle_to_rotate = dir.angle_to(Vector2.UP)
	rotate(angle_to_rotate)

func _on_body_entered(body):
	print("AAAAAAAAAAAAAA")
