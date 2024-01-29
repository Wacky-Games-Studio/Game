extends Camera2D

@export var move_speed: float = .8
@export var instant_move: bool = false

@onready var notifier: VisibleOnScreenNotifier2D = $"../OnScreenNotifier"
@onready var player: CharacterBody2D = $".."

var _locked := false
var _is_static := true

func _ready() -> void:
	set_static(_is_static)
	update_position()

func update_position() -> void:	
	if _is_static:
		global_position = _calculate_new_pos()

func _calculate_new_pos() -> Vector2:
	if _locked: return global_position
	
	var viewport_size := get_viewport_rect().size
	var player_offset_x := fposmod(player.global_position.x, viewport_size.x)
	var player_offset_y := fposmod(player.global_position.y, viewport_size.y)
	
	var target_pos := Vector2.ZERO
	
	target_pos.x = player.global_position.x - player_offset_x + (viewport_size.x / 2)
	target_pos.y = player.global_position.y - player_offset_y + (viewport_size.y / 2)
	
	return target_pos

func _on_screen_notifier_screen_exited() -> void:
	if _is_static == false:
		return
	
	var target_pos = _calculate_new_pos()
	
	if target_pos == global_position:
		var viewport_size := get_viewport_rect().size
		player.global_position.y -= viewport_size.y
	
	if instant_move:
		global_position = target_pos
		return
	
	SceneManager.pause_scene()
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "global_position", target_pos, move_speed)
	await tween.finished
	
	SceneManager.start_scene()

func lock() -> void:
	_locked = true

func unlock() -> void:
	_locked = false

func set_static(value: bool) -> void:
	_is_static = value
	
	var original_pos = get_screen_center_position()
	
	drag_horizontal_enabled = _is_static == false
	drag_vertical_enabled = _is_static == false
	top_level = _is_static == true
	
	global_position = original_pos
	
	if _is_static == false:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", Vector2(0,0), 0.5)
	else:
		var target_pos = _calculate_new_pos()
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
		tween.tween_property(self, "global_position", target_pos, move_speed)

func is_static() -> bool:
	return _is_static

func restrict_camera(rect: Rect2, movement_flags: int) -> void:
	var lock_left  = (movement_flags & (1 << 0)) != 0
	var lock_right = (movement_flags & (1 << 1)) != 0
	var lock_up    = (movement_flags & (1 << 2)) != 0
	var lock_down  = (movement_flags & (1 << 3)) != 0
	
	if rect.size.x == 0:
		var tween = get_tree().create_tween().set_parallel(true)
		if lock_right: tween.tween_property(self, "limit_right", 10000000, 10.0)
		if lock_left : tween.tween_property(self, "limit_left", -10000000, 10.0)
		if lock_up   : tween.tween_property(self, "limit_top", -10000000, 10.0)
		if lock_down : tween.tween_property(self, "limit_bottom",10000000, 10.0)
		return 
	
	if lock_right: limit_right  = rect.position.x + floorf(rect.size.x / 2.0)
	if lock_left : limit_left   = rect.position.x - floorf(rect.size.x / 2.0)
	if lock_up   : limit_top    = rect.position.y - floorf(rect.size.y / 2.0)
	if lock_down : limit_bottom = rect.position.y + floorf(rect.size.y / 2.0)
