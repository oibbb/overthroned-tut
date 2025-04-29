extends CharacterBody2D

var input 
@export var speed = 100.0
@export var gravity = 10

#Variable for Jumping
var jump_count = 0
@export var max_jump = 2
@export var jump_force = 500

# wall jump
@onready var wall = $wall_ray

# ABOUT DASHING
@export var dash_force = 600

# EVERYTHING RELATED TO STATE MACHINE
var current_state = player_states.MOVE
enum player_states {MOVE, SWORD, DEAD, DASH}

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sword/sword_collider.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Player_Data.life <= 0:
		current_state = player_states.DEAD

	
	match current_state:
		player_states.MOVE:
			movement(delta)
		player_states.SWORD:
			sword(delta)
		player_states.DASH:
			dashing()
		player_states.DEAD:
			dead()



func movement(delta):
	input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if input != 0:
		if  input > 0:
			velocity.x += speed * delta
			velocity.x = clamp(speed, 100.0, speed)
			$Sprite2D.scale.x = 1
			wall.scale.x = 1 
			$Sword.position.x = 19
			$Anim.play("Walk")
		if  input < 0:
			velocity.x -= speed * delta
			velocity.x = clamp(-speed, 100.0, -speed)
			$Sprite2D.scale.x = -1
			wall.scale.x = -1 
			$Sword.position.x = -19
			$Anim.play("Walk")
			
	if input == 0:
		velocity.x = 0
		$Anim.play("Idle")
		
		
	
# Code related to Jumping
	if is_on_floor():
		jump_count = 0
	if !is_on_floor():
		if velocity.y < 0:
			$Anim.play("Jump")
		if velocity.y > 0:
			$Anim.play("Fall")
			
	if Input.is_action_just_pressed("ui_accept") && is_on_floor() && jump_count < max_jump:
		jump_count += 1
		velocity.y -= jump_force
		velocity.x = input
	if !is_on_floor() && Input.is_action_just_pressed("ui_accept") && jump_count < max_jump:
		jump_count += 1
		velocity.y -= jump_force * 1.2
		velocity.x = input
	if !is_on_floor() && Input.is_action_just_released("ui_accept") && jump_count < max_jump:
		velocity.y = gravity
		velocity.x = input
	else:
		gravity_force()
		
	if wall_collider() && Input.is_action_just_pressed("ui_accept"):
		if velocity.x > 0: # to the right
			velocity = Vector2(-800, -370)
		elif velocity.x < 0: # to the left
			velocity = Vector2(800, -370)
	
	if Input.is_action_just_pressed("ui_Sword"):
		current_state = player_states.SWORD
		
	if Input.is_action_just_pressed("ui_dash"):
		current_state = player_states.DASH
	
	gravity_force()
	move_and_slide()
	
func gravity_force():
	if !wall_collider(): # wall slide
		velocity.y += gravity
	elif wall_collider():
		velocity.y += 0.5

func sword(delta):
	$Anim.play("Sword")
	input_movement(delta)
	
func dead():
	$Anim.play("Dead")
	velocity.x = 0
	await $Anim.animation_finished
	Player_Data.life = 4
	if get_tree():
		get_tree().reload_current_scene()
	
func dashing():
	if velocity.x > 0:
		velocity.x += dash_force
		await get_tree().create_timer(0.1).timeout
		current_state = player_states.MOVE
	elif velocity.x < 0:
		velocity.x -= dash_force
		await get_tree().create_timer(0.1).timeout
		current_state = player_states.MOVE
	else:
		if $Sprite2D.scale.x == 1:
			velocity.x += dash_force
		await get_tree().create_timer(0.1).timeout
		current_state = player_states.MOVE
		if $Sprite2D.scale.x == -1:
			velocity.x -= dash_force
		await get_tree().create_timer(0.1).timeout
		current_state = player_states.MOVE
		
	move_and_slide()



func input_movement(delta):
	input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if input != 0:
		if  input > 0:
			velocity.x += speed * delta
			velocity.x = clamp(speed, 100.0, speed)
			$Sprite2D.scale.x = 1

		if  input < 0:
			velocity.x -= speed * delta
			velocity.x = clamp(-speed, 100.0, -speed)
			$Sprite2D.scale.x = -1
	
	if input == 0:
		velocity.x = 0
		
	gravity_force()
	move_and_slide()

func wall_collider():
	return wall.is_colliding()

func reset_states():
	current_state = player_states.MOVE
