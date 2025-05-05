extends State


func enter():
	super.enter()
	combo()

func attack(move = "1"):
	animation_player.play("Attack" + move)
	await animation_player.animation_finished

func combo():
	var move_set = ["1","2","3"]
	for i in move_set:
		await attack(i)
	combo()

func transition():
	if owner.direction.length()> 40:
		get_parent().change_state("Walking")
