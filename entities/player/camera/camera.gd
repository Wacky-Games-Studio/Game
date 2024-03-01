extends Camera2D

@export var move_speed: float = .8
@export var instant_move: bool = false

@onready var notifier: VisibleOnScreenNotifier2D = $"../OnScreenNotifier"
@onready var player: CharacterBody2D = $".."
@onready var screen_size: Vector2 = get_viewport().get_visible_rect().size

var _locked := false
var _is_static := true
var _target_distance := 100
var _camera_speed := 100
var _camera_lockers: Array[CameraLocker] = []
var _queued_left: int
var _queued_top: int
var _queued_right: int
var _queued_bottom: int

func _ready() -> void:
	set_static(_is_static)
	update_position()

func _process(delta):
	if _is_static: return
	
	#var path: Path2D = get_node("/root/Level_1/Path2D")
	#global_position = path.curve.get_closest_point(player.global_position - path.global_position) + path.global_position
	
	var new_offset: float = global_position.x
	if player.velocity.x > 0:
		var target = (player.position.x + _target_distance)
		new_offset = min(new_offset + _camera_speed * delta, target)
	elif player.velocity.x < 0:
		var target = (player.position.x - _target_distance)
		new_offset = max(new_offset - _camera_speed * delta, target)

	global_position.x = new_offset

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
	
	limit_right  =  10000000
	limit_left   = -10000000
	limit_top    = -10000000
	limit_bottom =  10000000
	
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
	
	#drag_horizontal_enabled = _is_static == false
	#drag_vertical_enabled = _is_static == false
	top_level = _is_static == true
	
	global_position = original_pos
	
	if _is_static == false:
		var tween = get_tree().create_tween()
		#tween.tween_property(self, "position", Vector2(0,0), 0.5)
		tween.tween_method(_move_camera, position, Vector2(0,0), 0.5)
		limit_right  = _queued_right
		limit_left   = _queued_left
		limit_top    = _queued_top
		limit_bottom = _queued_bottom
	else:
		var target_pos = _calculate_new_pos()
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
		tween.tween_property(self, "global_position", target_pos, move_speed)

func _move_camera(pos: Vector2) -> void:
	position = Vector2(clamp(pos.x, limit_left - global_position.x, limit_right - global_position.x), clamp(pos.y, limit_top - global_position.y, limit_bottom - global_position.y))

func is_static() -> bool:
	return _is_static

var limit_tween: Tween

func restrict_camera(rect: Rect2, movement_flags: int, locker: CameraLocker) -> void:
	var lock_left  = (movement_flags & (1 << 0)) != 0
	var lock_right = (movement_flags & (1 << 1)) != 0 
	var lock_up    = (movement_flags & (1 << 2)) != 0
	var lock_down  = (movement_flags & (1 << 3)) != 0
	
	if rect.size.x == 0:
		_camera_lockers.erase(locker)
		if _camera_lockers.size() > 0: return
		
		if get_tree() == null: return # DO NOT REMOVE. GAME CRASHES WHEN CLOSING IF IT ISN'T THERE
		if lock_right: limit_right  =  10000000
		if lock_left : limit_left   = -10000000
		if lock_up   : limit_top    = -10000000
		if lock_down : limit_bottom =  10000000
		return 
	
	_camera_lockers.push_back(locker)
	
	if lock_right: limit_right  = int(rect.position.x + floorf(rect.size.x / 2.0))
	if lock_left : limit_left   = int(rect.position.x - floorf(rect.size.x / 2.0))
	if lock_up   : limit_top    = int(rect.position.y - floorf(rect.size.y / 2.0))
	if lock_down : limit_bottom = int(rect.position.y + floorf(rect.size.y / 2.0))

	_queued_right  = limit_right
	_queued_left   = limit_left
	_queued_top    = limit_top
	_queued_bottom = limit_bottom
	
