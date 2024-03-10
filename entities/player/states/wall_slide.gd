extends State

@export var idle_state: State
@export var move_state: State
@export var fall_state: State
@export var wall_jump_state: State

var direction_of_slide: float

func enter() -> void:
	super()
	var dir = Input.get_axis("walk_left", "walk_right")
	direction_of_slide = dir

func process_physics(delta: float) -> State:
	var dir = Input.get_axis("walk_left", "walk_right")
	
	if Input.is_action_just_pressed("jump"):
		return wall_jump_state
	
	if dir == 0 or dir != direction_of_slide or (dir == 1 and not parent.wall_raycasts.right) or (dir == -1 and not parent.wall_raycasts.left):
		return fall_state
	
	parent.velocity.y = parent.get_clamped_gravity(delta) * parent.data.wall_slide_speed
	parent.move_and_slide()
	
	if parent.is_on_floor_raycasts(): 
		parent.has_jumped = false
		return idle_state if dir == 0 else move_state
	return null
