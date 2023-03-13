extends RigidBody2D

@onready var ropeline: Line2D = $Line2D

var x_span: float = 100.0
var amplitude: float = 7.0
var period: float = 5.0
@onready var x_jump: float = x_span / len(ropeline.points)

var time_elapsed: float = 0.0
const LIFETIME: float = 6.0

# Called when the node enters the scene tree for the first time.
func _ready():
	wiggle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_elapsed += delta
	wiggle()

	if time_elapsed >= LIFETIME:
		queue_free()

func wiggle():
	for i in len(ropeline.points):
		ropeline.set_point_position(i, Vector2(i * x_jump + 50.0 * time_elapsed, sin((i * x_jump + time_elapsed * 200.0) / period) * amplitude * randf_range(0.8, 1.0)))
