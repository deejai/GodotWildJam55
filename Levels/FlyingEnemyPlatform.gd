extends Enemy

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var leftbound: Vector2 = $LeftBound.global_position
@onready var rightbound: Vector2 = $RightBound.global_position

var speed: float = 100.0
var direction: Vector2 = Vector2.RIGHT

var nullified: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	enemy_process()
	
	if nullified:
		return
	elif sleeping:
		remove_child($Area2D)
		nullified = true
		sprite.animation = "sleeping"
		$ZParticles.visible = true
		return

	position += direction * speed * delta

	if direction == Vector2.RIGHT:
		if position.x > rightbound.x:
			direction = Vector2.LEFT
			sprite.flip_h = false
	elif direction == Vector2.LEFT:
		if position.x < leftbound.x:
			direction = Vector2.RIGHT
			sprite.flip_h = true
