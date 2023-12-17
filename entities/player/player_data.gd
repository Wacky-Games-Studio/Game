extends Resource
class_name PlayerData

@export_category("Ground")
@export var move_speed: float = 16
@export_range(0.0, 1.0) var ground_acceleration: float = 1
@export_range(0.0, 1.0) var ground_deceleration: float = 1
@export var convserve_momentum: bool = true

@export_category("Jump/Fall")
#@export var gravity: float = 16
@export var max_jump_height: float
@export var min_jump_height: float
@export var jump_time_to_peak: float
@export var jump_time_to_descent: float
@export var terminal_velocity: float = 600
@export_range(0.0, 1.0) var wall_jump_lerp: float
