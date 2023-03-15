extends Node2D

class_name Rope

@onready var ropeline: Line2D = $Line2D
var anchor_point: Vector2
var dangle_body: RigidBody2D
var draw_to: Node2D

var x_dir: float
var y_dir: float

const ANCHOR_FORCE: float = 300.0
var total_impulse: float = 0.0

const FORCE_TIME: float = 0.6
var timer: float = FORCE_TIME

# Called when the node enters the scene tree for the first time.
func _ready():
	ropeline.set_point_position(0, anchor_point)
	ropeline.set_point_position(1, draw_to.global_position)

	x_dir = -1.0 if dangle_body.position.x > anchor_point.x else 1.0
	y_dir = -1.0 if dangle_body.position.y > anchor_point.y else 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ropeline.set_point_position(1, draw_to.global_position)

	var anchor_vector: Vector2 = anchor_point - dangle_body.global_position

	var rope_force: Vector2 = Vector2(anchor_vector.x + 200.0 * x_dir, anchor_vector.y + 350.0 * y_dir)

	dangle_body.apply_central_force(rope_force)

	timer -= delta
	if timer < 0.0:
		queue_free()
