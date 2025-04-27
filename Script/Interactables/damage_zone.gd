extends Area2D
#NOTE: IF YOU WANT TO FLIP THE SPIKE, CHANGE THE SPECIFIC SPIKE IN THE LEVEL'S Y_SCALE TO -1
 
@export var current_state:spike_state
enum spike_state {ACTIVE, ANIMATED}

func _process(delta):
	match current_state:
		spike_state.ACTIVE:
			active()
		spike_state.ANIMATED:
			active_animated()

#the static state of the spike
func active():
	$anim.play("Active")

#state of the spike with animations
func active_animated():
	$anim.play("Active_Animated")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Player_Data.life -= 1
