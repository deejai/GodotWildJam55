extends Area2D

@onready var spawn_player: AudioStreamPlayer2D = $SpawnPlayer
@onready var hit_player: AudioStreamPlayer2D = $HitPlayer
@onready var dud_player: AudioStreamPlayer2D = $DudPlayer

var sand_particles: GPUParticles2D = load("res://Particles/SandThrow.tscn").instantiate()
var bonus_velocity: Vector2 = Vector2.ZERO

var timer: float = 0.0
const LIFETIME: float = 2.0

var collided: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_player.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	position += (bonus_velocity + Vector2.RIGHT.rotated(rotation) * 200.0) * delta
	if timer >= LIFETIME:
		collided = true
		visible = false
	
	if timer > LIFETIME + 1.0:
		queue_free()

func _on_body_entered(body):
	if collided:
		return

	if body is Player:
		return

	if body is Enemy:
		hit_player.play()
		body.sleeping = true
		body.modulate.r = 1.1
		body.modulate.b = 1.1
		body.modulate.g = 0.8
	else:
		dud_player.play()

	collided = true
	visible = false
