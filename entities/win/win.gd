extends Area2D

@export var collision_size: Vector2
@export var collider_position: Vector2

func _ready():
	var rect := RectangleShape2D.new()
	rect.size = collision_size
	$CollisionShape2D.shape = rect
	$CollisionShape2D.position = collider_position

func _on_body_entered(body) -> void:
	if body is Player:
		SceneManager.finnish_level()
