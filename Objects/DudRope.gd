extends RigidBody2D

@onready var ropeline: Line2D = $Line2D

var x_span: float = 100.0
var amplitude: float = 10.0
var period: float = 5.0
@onready var x_jump: float = x_span / len(ropeline.points)

var time_elapsed: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	wiggle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_elapsed += delta
	wiggle()

func wiggle():
	for i in len(ropeline.points):
		ropeline.set_point_position(i, Vector2(i * x_jump, sin((i * x_jump + time_elapsed * time_elapsed * 100.0) / period) * amplitude * randf_range(0.8, 1.0)))
