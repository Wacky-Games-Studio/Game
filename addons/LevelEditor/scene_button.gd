@tool
class_name SceneButton
extends TextureButton

@export var clicked = false
signal scene_clicked(button: SceneButton)

@onready var highlight: TextureRect = $Highlight
@onready var select: TextureRect = $Select
@onready var selected: TextureRect = $Selected

var path: String

func init(texture: Texture2D, path: String):
	texture_normal = texture
	tooltip_text = "Path: " + path
	self.path = path

func _process(_delta):
	highlight.visible = is_hovered()
	selected.visible = button_pressed or clicked
	select.visible = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and is_hovered()

func _on_pressed():
	scene_clicked.emit(self)
	clicked = true

func un_click():
	clicked = false
