extends Sprite2D

@export var move_speed: float = 200.0
@export var move_left := false

func _ready():
	flip_h = move_left

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	#if GlobalState.camera_moving:
	#	return
	
	position.x += move_speed * delta * (-1 if move_left else 1)

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
