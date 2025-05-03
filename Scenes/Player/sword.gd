extends Area2D

signal hit(target)

func _on_area_entered(area):
	if area.is_in_group("samurai_wannabe"):
		emit_signal("hit", area)


func _on_player_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass # Replace with function body.
