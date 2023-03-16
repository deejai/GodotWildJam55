extends StaticBody2D

@onready var leftbound: Vector2 = $LeftBound.global_position
@onready var rightbound: Vector2 = $RightBound.global_position

var speed: float = 100.0
var direction: Vector2 = Vector2.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * speed * delta

	if direction == Vector2.RIGHT:
		if position.x > rightbound.x:
			direction = Vector2.LEFT
	elif direction == Vector2.LEFT:
		if position.x < leftbound.x:
			direction = Vector2.RIGHT
