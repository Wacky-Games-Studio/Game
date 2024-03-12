extends State

@export var idle_state: State
@export var move_state: State
@export var jump_state: State
@export var wall_slide_state: State
@export var wall_jump_state: State

@onready var coyote_timer: Timer = %CoyoteTimer

func enter() -> void:
	super()
	coyote_timer.start()

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump") and not coyote_timer.is_stopped() and not parent.has_jumped and not parent.has_spring_jumped: return jump_state
	return null

func process_physics(delta: float) -> State:
	var dir = Input.get_axis("walk_left", "walk_right")
	parent.velocity.x += parent.get_movement_velocity(dir)
	parent.velocity.y = parent.get_clamped_gravity(delta)
	parent.move_and_slide()
	
	if parent.walljump_enabled and parent.is_on_wall_custom() and Input.is_action_just_pressed("jump"):
		return wall_jump_state
	
	if parent.walljump_enabled and ((dir == 1 and parent.is_on_wall_right()) or (dir == -1 and parent.is_on_wall_left())):
		return wall_slide_state
	
	if parent.is_on_floor_raycasts():
		parent.sprite.scale = Vector2(1.3, 0.7)
		parent.has_jumped = false
		parent.has_spring_jumped = false
		return idle_state if dir == 0 else move_state
	return null
