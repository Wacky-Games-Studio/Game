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
	if InputBuffer.is_action_press_buffered("jump") and not coyote_timer.is_stopped() and not parent.has_jumped: return jump_state
	return null

func process_physics(delta: float) -> State:
	var dir = Input.get_axis("walk_left", "walk_right")
	parent.velocity.x += parent.get_movement_velocity(dir)
	parent.velocity.y = parent.get_clamped_gravity(delta)
	parent.move_and_slide()
	
	if (parent.wall_raycasts.left or parent.wall_raycasts.right) and Input.is_action_just_pressed("jump"):
		return wall_jump_state
	
	if (dir == 1 and parent.wall_raycasts.right) or (dir == -1 and parent.wall_raycasts.left):
		return wall_slide_state
	
	if parent.is_on_floor_raycasts(): 
		parent.has_jumped = false
		return idle_state if dir == 0 else move_state
	return null
