extends Camera2D

@export var move_speed: float = .8
@export var instant_move: bool = false

@export_category("Dynamic camera")
@export var target_distance := 16.0
@export var camera_speed := 100.0
@export var buffer_size := 32.0

@onready var notifier: VisibleOnScreenNotifier2D = $"../OnScreenNotifier"
@onready var player: CharacterBody2D = $".."
@onready var screen_size: Vector2 = get_viewport().get_visible_rect().size

var _locked := false
var _is_static := true
var _camera_lockers: Array[CameraLocker] = []
var _queued_left: int
var _queued_top: int
var _queued_right: int
var _queued_bottom: int
var _lerp_target: float
var _should_lerp: bool
var _start_lerp_position: float
var _lerp_timer: float
var _current_state: DynamicState = DynamicState.MovingRight

enum DynamicState {
	MovingRight,
	MovingLeft,
	None
}

func _ready() -> void:
	set_static(_is_static)
	update_position()
	#Engine.time_scale = 0.1

func _physics_process(delta: float) -> void:
	if _is_static: return
	
	var center_position: float = get_screen_center_position().x
	var buffer_max: float = center_position + target_distance + buffer_size
	var buffer_min: float = center_position - target_distance - buffer_size
	
	if player.global_position.x > buffer_max and player.velocity.x > 0 and _should_lerp == false:
		_start_lerp(target_distance, DynamicState.MovingRight)

	elif player.global_position.x < buffer_min and player.velocity.x < 0 and _should_lerp == false:
		_start_lerp(-target_distance, DynamicState.MovingLeft)
	
	if _should_lerp:
		_update_lerp_position(delta)
		return

	_update_global_position()

func _start_lerp(target: float, state: DynamicState) -> void:
	_lerp_target = target
	_should_lerp = true
	_start_lerp_position = global_position.x
	_lerp_timer = 0.0
	_current_state = state

func _update_lerp_position(delta: float) -> void:
	var target = player.global_position.x + _lerp_target
		
	_lerp_timer += camera_speed * delta
	global_position.x = lerpf(_start_lerp_position, target, _lerp_timer)
	if _lerp_timer >= 1.0:
		_should_lerp = false

func _update_global_position() -> void:
	if _current_state == DynamicState.MovingRight and player.velocity.x > 0 and player.global_position.x > global_position.x - target_distance:
		global_position.x = player.global_position.x + target_distance
	elif _current_state == DynamicState.MovingLeft and player.velocity.x < 0 and player.global_position.x < global_position.x + target_distance:
		global_position.x = player.global_position.x - target_distance
	
func _process(_delta):
	queue_redraw()

func _draw():
	if not get_tree().debug_collisions_hint:
		return

	#var new_offset: float = global_position.x
	var center: float = get_screen_center_position().x
	var player_buffer_max: float = target_distance + center + buffer_size
	var player_buffer_min: float = -target_distance + center - buffer_size
	#var player_position_diff: float = center - player.global_position.x

	
	draw_rect(Rect2(to_local(Vector2(player_buffer_min, 0)), Vector2(2, 272)), Color.BLUE)
	draw_rect(Rect2(to_local(Vector2(player_buffer_max, 0)), Vector2(2, 272)), Color.GREEN)

	# middle
	draw_line(to_local(Vector2(center, 0)), to_local(Vector2(center, 272)), Color.RED, 2);
	draw_line(to_local(Vector2(center - target_distance, 0)), to_local(Vector2(center - target_distance, 272)), Color.PINK, 2)
	draw_line(to_local(Vector2(center + target_distance, 0)), to_local(Vector2(center + target_distance, 272)), Color.YELLOW, 2)

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
	
	# HACK: what???
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
	#top_level = _is_static == true
	
	global_position = original_pos
	
	if _is_static == false:
		limit_right  = _queued_right
		limit_left   = _queued_left
		limit_top    = _queued_top
		limit_bottom = _queued_bottom

		# if   player.velocity.x > 0: _start_lerp(target_distance, DynamicState.MovingRight)
		# elif player.velocity.x < 0: _start_lerp(-target_distance, DynamicState.MovingLeft)

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
	
