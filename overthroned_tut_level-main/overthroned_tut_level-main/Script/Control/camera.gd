extends Camera2D

@onready var player = $"../Player"

func _ready():
	pass
	
func _process(delta):
	camera_follow()
	
func camera_follow():
	anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
	position = player.position
