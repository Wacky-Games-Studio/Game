class_name Player
extends CharacterBody2D

@export var speed := 200
@export var jump_speed := -450
@export var wall_jump_pushback := -225
@export var gravity := 2000
@export var wall_slide_gravity := 100
@export var max_jumps := 1
@export_range(0.0, 1.0) var friction := 0.3
@export_range(0.0 , 1.0) var acceleration := 0.4

@onready var sprite: Sprite2D = $Sprite
@onready var state_machine: Node = $StateMachine

var jumps_remaining := max_jumps

func _ready() -> void:
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
