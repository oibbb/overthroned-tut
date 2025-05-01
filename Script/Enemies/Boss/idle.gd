extends State

@onready var collision_shape_2d = $"../../PlayerDetection/CollisionShape2D"
@onready var progress_bar = owner.find_child("ProgressBar")

var Player_entered: bool = false:
	set(value):
		Player_entered = value
		collision_shape_2d.set_deferred("disabled", value)
		progress_bar.set_deferred("visible", value)

func _on_player_detection_body_entered(body: Node2D) -> void:
	Player_entered = true

func transition():
	if Player_entered:
		get_parent().change_state("Walking")
