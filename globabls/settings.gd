extends Control

signal just_hidden()

@export var audio_bus_name := "Master"
@export var volume_offset_db := 0.0
@export var inital_volume_offset_db := 0.0
@onready var bus := AudioServer.get_bus_index(audio_bus_name)
@onready var vol_slider: HSlider = %VolSlider;
@onready var full_screen: OptionButton = %FullscreenMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	vol_slider.value = db_to_linear(abs(AudioServer.get_bus_volume_db(bus) + volume_offset_db) + inital_volume_offset_db)

func _on_fullscren_item_selected(index:int):
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_volume_slider_value_changed(value:float):
	AudioServer.set_bus_volume_db(bus, linear_to_db(value) + volume_offset_db)


func _on_reset_progress_pressed():
	DirAccess.remove_absolute("user://savegame.save")

func _on_back_button_pressed():
	var settings_file = FileAccess.open("user://settings", FileAccess.WRITE)
	var save = {
		volume = abs(AudioServer.get_bus_volume_db(bus) + volume_offset_db) + inital_volume_offset_db,
		fullscrenn = DisplayServer.window_get_mode()
	};

	settings_file.store_string(JSON.stringify(save))
	settings_file.close()

	get_parent().hide()


func _on_canvas_layer_visibility_changed():
	if get_parent().visible:
		full_screen.grab_focus()
	else:
		just_hidden.emit()