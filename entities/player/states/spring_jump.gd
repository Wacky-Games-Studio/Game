extends State

@export var fall_state: State
@export var wall_jump_state: State

@onready var wall_jump_timer: Timer = %WallJumpTime

func enter() -> void:
	super()
	parent.velocity = parent.spring_jump_dir * (parent.jump_velocity * parent.data.spring_jump_multiplier)
	#if parent.velocity.x != 0:
		#parent.velocity.x *= 1.25

	parent.has_spring_jumped = true
	wall_jump_timer.start()
	print(parent.velocity)

func process_physics(delta: float) -> State:
	if (parent.wall_raycasts.left or parent.wall_raycasts.right) and Input.is_action_just_pressed("jump"):
		pass
		#return wall_jump_state
	
	var dir = Input.get_axis("walk_left", "walk_right")
	parent.velocity.x += parent.get_movement_velocity(dir, parent.data.wall_jump_lerp if not wall_jump_timer.is_stopped() else 1.0)
	parent.velocity.y = parent.get_clamped_gravity(delta)
	
	parent.nudge()
	parent.move_and_slide()
	
	if parent.was_nudged:
		parent.velocity.x = parent.nudge_keep_velocity.x
	
	if parent.velocity.y > 0: 
		return fall_state
	
	return null
