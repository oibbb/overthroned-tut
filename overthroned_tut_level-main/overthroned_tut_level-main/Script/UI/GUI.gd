extends CanvasLayer

const HEALTH_ROW_SIZE = 8
const HEALTH_OFFSET = 16

func _ready():
	for i in Player_Data.life:
		var new_health = Sprite2D.new()
		new_health.texture = $Player_Health.texture
		new_health.hframes = $Player_Health.hframes
		$Player_Health.add_child(new_health)

func _process(_delta):
	display_health()

func display_health():
	for health in $Player_Health.get_children():
		var index = health.get_index()
		var x = (index % HEALTH_ROW_SIZE) * HEALTH_OFFSET
		var y = (index / HEALTH_ROW_SIZE) * HEALTH_OFFSET
		health.position = Vector2(x, y)
		
		var last_health = floor(Player_Data.life)
		if index > last_health:
			health.frame = 0
		if index == last_health:
			health.frame = (Player_Data.life - last_health) * 4
		if index < last_health:
			health.frame = 4
