extends Line2D

@onready var path = $".."

# Called when the node enters the scene tree for the first time.
func _ready():
	for point in path.curve.get_baked_points():  
		add_point(point)
