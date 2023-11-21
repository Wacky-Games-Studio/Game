extends State

@export var move_state: State
@export var idle_state: State
@export var jump_state: State
@export var wall_slide_state: State

@onready var coyote_timer: Timer = %CoyoteTimer


func enter() -> void:
	super()

func process_input(_event: InputEvent) -> State:
	
	# coyote timer
	if Input.is_action_just_pressed("jump") and not coyote_timer.is_stopped() and parent.jumps_remaining > 0:
		return jump_state

	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += parent.get_gravity() * delta if min(parent.velocity.y, parent.terminal_fall_velocity) != parent.terminal_fall_velocity else 0.0
	
	var dir = Input.get_axis("walk_left", "walk_right")
	
	if parent.is_on_wall_only() and not parent.is_moving_away_from_wall():
		return wall_slide_state
	
	if dir != 0:
		parent.velocity.x = lerp(parent.velocity.x, dir * parent.speed, parent.air_acceleration)
		parent.flip(dir < 0)
	else:
		parent.velocity.x = lerp(parent.velocity.x, 0.0, parent.air_friction)

	parent.move_and_slide()
	
	if parent.is_on_floor():
		parent.jumps_remaining = parent.max_jumps
		parent.spawn_dust(Player.ParticlesType.Land)
		parent.is_spring_jump = false
		if dir != 0:
			return move_state
		return idle_state
	
	return null
