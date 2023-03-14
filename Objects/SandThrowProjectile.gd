extends Area2D

@onready var sfx_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
var sand_particles: GPUParticles2D = load("res://Particles/SandThrow.tscn").instantiate()
var bonus_velocity: Vector2 = Vector2.ZERO

var timer: float = 0.0
const LIFETIME: float = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	sfx_player.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	position += (bonus_velocity + Vector2.RIGHT.rotated(rotation) * 200.0) * delta
	if timer >= LIFETIME:
		queue_free()
