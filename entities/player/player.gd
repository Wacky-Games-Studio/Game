class_name Player
extends PausableEntity

@export var data: PlayerData

@export_category("Particles")
@export var walk_particles: PackedScene
@export var jump_particels: PackedScene
@export var land_particels: PackedScene

@onready var sprite: Sprite2D = $Sprite
@onready var state_machine: Node = $StateMachine
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var particle_holder: Node2D = $Particles
@onready var audio_controller: Node2D = $AudioController
@onready var blood_particles: CPUParticles2D = $Particles/Blood
@onready var reverse_blood_particles: CPUParticles2D = $Particles/ReverseBlood
@onready var death_audio: AudioStreamPlayer2D = $DeathAudio
@onready var death_reverse_audio: AudioStreamPlayer2D = $DeathAudio
@onready var ceiling_raycasts: CeilingRaycasts = $Raycasts/CeilingRaycasts
@onready var wall_raycasts: WallRaycasts = $Raycasts/WallRaycasts
@onready var floor_raycasts: FloorRaycasts = $Raycasts/FloorRayCasts
@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var light: PointLight2D = $PointLight2D

# jump / gravity vars
@onready var jump_velocity: float = ((2.0 * data.max_jump_height) / data.jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * data.max_jump_height) / (data.jump_time_to_peak * data.jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * data.max_jump_height) / (data.jump_time_to_descent * data.jump_time_to_descent)) * -1.0
@onready var variable_gravity: float = (jump_velocity * jump_velocity) / (2 * data.min_jump_height)

var _current_walk_particles: CPUParticles2D
var _current_jump_particles: CPUParticles2D
var _current_land_particles: CPUParticles2D

var nudge_keep_velocity: Vector2
var was_nudged := false
var has_jumped := true
var has_spring_jumped := false
var spring_jump_dir := Vector2.ZERO
var walljump_enabled := true

func _ready() -> void:
	#Engine.time_scale = .1
	init()

func init() -> void:
	SceneManager.player = self
	state_machine.init(self)
	
	if CheckpointManager.has_collected_any():
		state_machine.change_state($StateMachine/Respawn)
	
	var cp_data := CheckpointManager.get_latest_checkpoint_data()
	global_position = cp_data.position
	flip_bool(cp_data.facing_left)
	
	$Camera.set_static(cp_data.static_camera)
	$Camera.update_position()
	
	_current_walk_particles = instantiate_new_particle(walk_particles)
	_current_jump_particles = instantiate_new_particle(jump_particels)
	_current_land_particles = instantiate_new_particle(land_particels)

func unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func physics_process(delta: float) -> void:
	sprite.scale.x = lerp(sprite.scale.x, 1.0, 5 * delta)
	sprite.scale.y = lerp(sprite.scale.y, 1.0, 5 * delta)
	
	state_machine.process_physics(delta)

func process(delta: float) -> void:
	state_machine.process_frame(delta)

func spawn_dust(type: ParticlesType = ParticlesType.Walk) -> void:
	match type:
		ParticlesType.Walk:
			_current_walk_particles.emitting = true
			_current_walk_particles = instantiate_new_particle(walk_particles)
		
		ParticlesType.Jump:
			audio_controller.play_jump_land()
			_current_jump_particles.emitting = true
			_current_jump_particles = instantiate_new_particle(jump_particels)
		
		ParticlesType.Land:
			audio_controller.play_jump_land()
			_current_land_particles.emitting = true
			_current_land_particles = instantiate_new_particle(land_particels)

enum ParticlesType {
	Walk = 0,
	Jump = 1,
	Land = 2
}

func flip_bool(should_flip: bool) -> void:
	sprite.flip_h = should_flip
	#$CollisionPolygon2D.scale = Vector2(-1 if should_flip else 1, 1)

func flip(dir: float) -> void:
	sprite.flip_h = dir < 0

func flip_opposite() -> void:
	sprite.flip_h = !sprite.flip_h

func instantiate_new_particle(particle_to_spawn: PackedScene) -> CPUParticles2D:
	var particle = particle_to_spawn.instantiate()
	particle_holder.add_child(particle)
	
	return particle

func _on_spike_detector_entered(_body):
	die()

func get_clamped_gravity(delta: float) -> float:
	var gravity = jump_gravity if velocity.y < 0.0 else fall_gravity
	
	if not Input.is_action_pressed("jump") and velocity.y < 0.0 and not has_spring_jumped:
		gravity = variable_gravity
	
	gravity *= delta
	var new_velocity = velocity.y + gravity
	if new_velocity > 0.0:
		new_velocity = clamp(velocity.y + gravity, 0.0, data.terminal_velocity)
	
	return new_velocity

func is_on_floor_raycasts() -> bool:
	return is_on_floor() and (floor_raycasts.left or floor_raycasts.center or floor_raycasts.right)

func get_movement_velocity(dir: float, lerp_amount: float = 1.0) -> float:
	if dir != 0.0: flip(dir)
	var target_speed := dir * data.move_speed
	target_speed = lerp(velocity.x, target_speed, lerp_amount)
	
	
	var accel_rate: float
	#var accel_rate := data.ground_acceleration if abs(target_speed) > 0 else data.ground_deceleration
	if has_jumped or has_spring_jumped:
		accel_rate = data.ground_acceleration * data.accel_in_air if abs(target_speed) > 0 else data.ground_deceleration * data.deccel_in_air
	else:
		accel_rate = data.ground_acceleration if abs(target_speed) > 0 else data.ground_deceleration
	
	# conserve momentum
	if should_conserve_momentum(target_speed):
		accel_rate = 0
	
	var speed_diff := target_speed - velocity.x
	var movement := speed_diff * accel_rate
	return movement

func should_conserve_momentum(target_speed: float) -> bool:
	var velocity_is_greater_then_max: bool = abs(velocity.x) > abs(target_speed)
	var moving_same_dir: bool = sign(velocity.x) == sign(target_speed) 
	var is_moving: bool = abs(target_speed) > 0
	var not_on_ground: bool = not is_on_floor_raycasts()
	
	return data.convserve_momentum and velocity_is_greater_then_max and moving_same_dir and is_moving and not_on_ground

func nudge() -> void:
	was_nudged = false
	nudge_keep_velocity = velocity
	
	var x_diff = (fmod(position.x, 16.0)) - 6.0
	var dir = Input.get_axis("walk_left", "walk_right")
	
	# ceiling left
	if ceiling_raycasts.left_outer and not ceiling_raycasts.left_inner and not ceiling_raycasts.right_inner and not ceiling_raycasts.right_outer and \
	   dir != 1:
		var ray: RayCast2D = ceiling_raycasts.get_node("left_outer")
		var node: Node2D = ray.get_collider()

		if node != null and node.is_in_group("Oneway") == false:
			position.x += x_diff
			was_nudged = true
	
	# ceiling right
	if ceiling_raycasts.right_outer and not ceiling_raycasts.left_inner and not ceiling_raycasts.right_inner and not ceiling_raycasts.left_outer and \
	   dir != -1:
		var ray: RayCast2D = ceiling_raycasts.get_node("right_outer")
		var node: Node2D = ray.get_collider()

		if node != null and node.is_in_group("Oneway") == false:
			position.x -= x_diff
			was_nudged = true

func spring_jump(dir: int) -> void:
	if (has_spring_jumped): return
	
	has_spring_jumped = true
	
	dir = mod_negative(dir, 360)
	
	if dir == 90: dir -= data.spring_jump_horizontal_direction_offset
	elif dir == 270: dir += data.spring_jump_horizontal_direction_offset
	
	# correct direction
	dir += 90
	var rad_dir := deg_to_rad(dir)
	 
	spring_jump_dir = Vector2(cos(rad_dir), sin(rad_dir))
	state_machine.change_state($StateMachine/SpringJump)

func get_wall_normal_rays_x() -> int:
	if wall_raycasts.left: return -1
	elif wall_raycasts.right: return 1
	else: return 0

func is_on_wall_custom() -> bool:
	var result := false

	if wall_raycasts.left:
		var ray: RayCast2D = wall_raycasts.get_node("left")
		var node: Node2D = ray.get_collider()
		if node != null and node.is_in_group("Oneway"):
			if int(node.rotation_degrees) == 90:
				result = true
			else:
				print(node.rotation_degrees)
				result = false
		else:
			result = true

	if wall_raycasts.right:
		var ray: RayCast2D = wall_raycasts.get_node("right")
		var node: Node2D = ray.get_collider()
		if node != null and node.is_in_group("Oneway"):
			if int(node.rotation_degrees) == 270:
				result = true
			else:
				result = false
		else:
			result = true

	return result

func mod_negative(x: int, n: int) -> int:
	return (x % n + n) % n

func die() -> void:
	if state_machine.current_state != $StateMachine/Dead:
		state_machine.change_state($StateMachine/Dead)

func set_static(is_static: bool) -> void:
	$Camera.set_static(is_static)

func restrict_camera(rect: Rect2, movement_flags: int, locker: CameraLocker) -> void:
	$Camera.restrict_camera(rect, movement_flags, locker)

func get_static_camera() -> bool:
	return $Camera.is_static()

func disable_canvas_modulate():
	canvas_modulate.visible = false
	light.enabled = false

func disable_walljump():
	walljump_enabled = false
