@tool

const MOVINGSAWBLADE := preload("res://entities/moving_saw_blade/moving_saw_blade.tscn")
const DOOR := preload("res://entities/door/door.tscn")
const BUTTON = preload("res://entities/door/button.tscn")
const CAMERA_TRIGGER = preload("res://entities/camera_trigger/camera_trigger.tscn")
const CAMERA_LOCKER = preload("res://entities/camera_locker/camera_locker.tscn")
const CHECKPOINT = preload("res://entities/checkpoint/checkpoint.tscn")
const SAW_BLADE = preload("res://entities/sawblade/saw_blade.tscn")
const SPRING = preload("res://entities/spring/spring.tscn")
const WIN = preload("res://entities/win/win.tscn")

var identifier_function := {
	"PlayerSpawn": _handle_player_spawn,
	"Sawblade": _handle_sawblade,
	"Button": _handle_button,
	"CameraTrigger": _handle_camera_trigger,
	"CameraLocker": _handle_camera_locker,
	"Checkpoint": _handle_checkpoint,
	"Spring": _handle_spring,
	"WinTrigger": _handle_win_trigger, 
}

var definition: Dictionary
var entities: Array

func post_import(entity_layer: LDTKEntityLayer) -> LDTKEntityLayer:
	definition = entity_layer.definition
	entities = entity_layer.entities
	for entity in entities:
		if identifier_function.has(entity.identifier):
			entity.position += Vector2i(entity_layer.position)
			identifier_function[entity.identifier].call(entity, entity_layer)
	
	return entity_layer

func _find_entity_by_id(iid: String):
	for entity in entities:
		if entity.iid == iid: return entity
	return null

func _handle_player_spawn(entity, entity_layer: LDTKEntityLayer) -> void:
	var playerSpawn := Marker2D.new()
	playerSpawn.position = entity.position
	playerSpawn.add_to_group("PlayerSpawn", true)
	
	entity_layer.add_child(playerSpawn)

func _handle_sawblade(entity, entity_layer: LDTKEntityLayer) -> void:
	if entity.fields.Path.size() > 0:
		var sawblade: MovingSawblade = MOVINGSAWBLADE.instantiate()
		sawblade.curve = Curve2D.new()
		sawblade.loop = entity.fields.Loop
		sawblade.loop_back = entity.fields.LoopBack
		sawblade.seconds_to_complete = entity.fields.SecondsToComplete
		sawblade.draw_rail = entity.fields.DrawRail
		
		sawblade.curve.add_point(entity.position)
		
		for pos: Vector2i in entity.fields.Path:
			if entity_layer.name == "EntitiesLargeGrid":
				sawblade.curve.add_point(pos * Vector2i(16, 16) + Vector2i(8, 8))
			elif entity_layer.name == "EntitiesPreciseGrid":
				sawblade.curve.add_point(pos * Vector2i(8, 8) + Vector2i(4, 4))
		
		entity_layer.add_child(sawblade)
	else:
		var sawblade: Sawblade = SAW_BLADE.instantiate()
		sawblade.position = entity.position
		
		entity_layer.add_child(sawblade)

func _handle_button(entity, entity_layer: LDTKEntityLayer) -> void:
	var door_iid = entity.fields.Door
	var btn_door = _find_entity_by_id(door_iid)
	
	var door: Door = DOOR.instantiate()
	var button: DuckButton = BUTTON.instantiate()
	
	door.position = btn_door.position
	button.position = entity.position - Vector2i(0, 5)
	
	button.door = door
	
	entity_layer.add_child(door)
	entity_layer.add_child(button)

func _handle_camera_trigger(entity, entity_layer: LDTKEntityLayer) -> void:
	var trigger: CameraTrigger = CAMERA_TRIGGER.instantiate()
	trigger.collision_size = Vector2(entity.size)
	trigger.collider_position = Vector2(entity.size / Vector2i(2, 2))
	trigger.position = entity.position
	
	match entity.fields.StaticSide:
		"Side.Left":
			trigger.static_side = CameraTrigger.StaticSide.Left
		"Side.Up":
			trigger.static_side = CameraTrigger.StaticSide.Top
		"Side.Right":
			trigger.static_side = CameraTrigger.StaticSide.Right
		"Side.Down":
			trigger.static_side = CameraTrigger.StaticSide.Down
	
	entity_layer.add_child(trigger)

func _handle_camera_locker(entity, entity_layer: LDTKEntityLayer) -> void:
	var locker: CameraLocker = CAMERA_LOCKER.instantiate()
	locker.collision_size = Vector2(entity.size)
	locker.collider_position = Vector2(entity.size / Vector2i(2, 2))
	locker.position = entity.position
	
	locker.lock_left = entity.fields.LockLeft
	locker.lock_up = entity.fields.LockUp
	locker.lock_right = entity.fields.LockRight
	locker.lock_down = entity.fields.LockDown
	
	entity_layer.add_child(locker)

func _handle_checkpoint(entity, entity_layer: LDTKEntityLayer) -> void:
	var checkpoint: Checkpoint = CHECKPOINT.instantiate()
	var checkpoint_colldier = _find_entity_by_id(entity.fields.CheckpointTrigger)
	
	print("entities ", entity_layer.global_position)
	
	checkpoint.collision_size = Vector2(checkpoint_colldier.size)
	checkpoint.collider_position = entity_layer.global_position + Vector2(checkpoint_colldier.position) + Vector2(checkpoint_colldier.size / Vector2i(2, 2))
	checkpoint.position = entity.position + Vector2i(0, -11)
	checkpoint.should_face_left_on_spawn = entity.fields.ShouldFaceLeft
	
	entity_layer.add_child(checkpoint)

func _handle_spring(entity, entity_layer: LDTKEntityLayer) -> void:
	var spring := SPRING.instantiate()
	spring.position = entity.position
	entity_layer.add_child(spring)

func _handle_win_trigger(entity, entity_layer: LDTKEntityLayer) -> void:
	var win := WIN.instantiate()
	win.collision_size = Vector2(entity.size)
	win.collider_position = Vector2(entity.size / Vector2i(2, 2))
	win.position = entity.position
	
	entity_layer.add_child(win)
