extends CharacterBody2D

@onready var player = get_parent().find_child("Player")
@onready var animated_sprite = $AnimatedSprite2D
@onready var progress_bar = $UI/ProgressBar
@export var move_speed = 40


var direction : Vector2
var damage_cooldown := false
var is_attacking := false

# Health and ProgressBar logic
var health := 10:
	set(value):
		health = value
		progress_bar.value = value
		if value <= 0:
			progress_bar.visible = false
			queue_free() 

func _ready():
	add_to_group("samurai_wannabe") # So player can detect and damage this boss
	progress_bar.max_value = health
	progress_bar.value = health
	$AttackArea.monitoring = true

func _process(_delta):
	# Flip sprite based on player's relative position
	if player:
		direction = player.position - position
		animated_sprite.flip_h = direction.x < 0
		

func _physics_process(delta):
	if player:
		velocity = direction.normalized() * move_speed
		move_and_slide()



# Called by the player's sword hitbox via signal or collision
func take_damage():
	health = health - 1
 

# Damages the player with cooldown to prevent spam
func damage_player():
	if not damage_cooldown:
		damage_cooldown = true
		is_attacking = true
		velocity = Vector2.ZERO
		animated_sprite.play("Attack1")
		Player_Data.life -= 1
		await get_tree().create_timer(1.0).timeout # 1 second cooldown
		damage_cooldown = false
		
func enable_hitbox():
	is_attacking = true
	$AttackArea.monitoring = true

func disable_hitbox():
	is_attacking = false
	$AttackArea.monitoring = false

		

func _on_attack_area_body_entered(body: Node2D) -> void:
	if is_attacking and body.name == "Player":
		Player_Data.life -= 1
		print("Sword hit the player!")
