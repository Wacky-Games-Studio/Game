extends Camera2D

@export var move_speed: float = .8
@export var instant_move: bool = false

@onready var notifier: VisibleOnScreenNotifier2D = $"../OnScreenNotifier"
@onready var player: CharacterBody2D = $".."

func _ready():
	update_position()

func update_position():
	global_position = _calculate_new_pos()

func _calculate_new_pos():
	var viewport_size := get_viewport_rect().size
	var player_offset_x := fposmod(player.global_position.x, viewport_size.x)
	var player_offset_y := fposmod(player.global_position.y, viewport_size.y)
	
	var target_pos := Vector2.ZERO
	
	target_pos.x = player.global_position.x - player_offset_x + (viewport_size.x / 2)
	target_pos.y = player.global_position.y - player_offset_y + (viewport_size.y / 2)
	
	return target_pos

func _on_screen_notifier_screen_exited():
	var target_pos = _calculate_new_pos()
	
	if instant_move:
		global_position = target_pos
		return
	
	GlobalState.pause_process()
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "global_position", target_pos, move_speed)
	await tween.finished
	
	GlobalState.start_process()
