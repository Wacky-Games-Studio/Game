extends Camera2D

@export var move_speed: float = .5

@onready var notifier: VisibleOnScreenNotifier2D = $"../OnScreenNotifier"
@onready var player: CharacterBody2D = $".."

func _ready():
	position_smoothing_enabled = false
	var viewport_size = get_viewport_rect().size
	global_position = viewport_size / 2
	await get_tree().create_timer(0.1).timeout
	position_smoothing_enabled = true

func _on_screen_notifier_screen_exited():
	var viewport_size = get_viewport_rect().size.x
	if global_position.x + viewport_size / 2 > player.position.x and \
	   global_position.x - viewport_size / 2 < player.position.x:
		return
	
	var new_val = global_position.x
	new_val += viewport_size if global_position < player.position else viewport_size * -1
	
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "global_position:x", new_val, move_speed)
	#global_position.x += 
