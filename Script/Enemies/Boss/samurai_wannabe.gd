extends CharacterBody2D

@onready var player = get_parent().find_child("Player")
@onready var animated_sprite = $AnimatedSprite2D

var direction : Vector2

func ready():
	set_physics_process(false)

func _process(_delta):
	direction = player.position - position
	
	if direction.x < 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false

func _physics_process(delta):
	velocity = direction.normalized() * 40
	move_and_collide(velocity * delta)





#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0


#func _physics_process(delta: float) -> void:
	# Add the gravity.
#	if not is_on_floor():
#		velocity += get_gravity() * delta

	# Handle jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
##	if direction:
#		velocity.x = direction * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)

#	move_and_slide()
