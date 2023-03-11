extends Node2D

const SPEED = 80.0
const JUMP_VELOCITY = -400.0

@onready var playerbody: RigidBody2D = $PlayerBody
@onready var bomb_timer: Timer = $PlayerBody/BombCooldown
@onready var bomb: Sprite2D = $PlayerBody/BombSprite
@onready var arm: ColorRect = $Arm
@onready var grab_area_L: Area2D = $Arm/Area2D
@onready var grab_area_collision_L: CollisionShape2D = $Arm/Area2D/CollisionShape2D
@onready var arm_pin_L: Vector2
@onready var bomb_explosion_particles: PackedScene = load("res://ExplosionParticles.tscn")
@onready var bomb_explosion_player: AudioStreamPlayer2D = $PlayerBody/BombSprite/AudioStreamPlayer2D

var explode_move_velocity: Vector2 = Vector2.ZERO

var max_extenstion: float = 150.0
var extension_len: float = 0.0
var grabbing_L: bool = false
var grabbing_timer_L: float = 0.0
var x_bonus_dir: Vector2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _process(delta):
	if not grabbing_L and Input.is_action_pressed("extend_L"):
		extension_len = min(max_extenstion, extension_len + 8.0 * delta * max_extenstion)

	if not Input.is_action_pressed("extend_L"):
		grabbing_L = false
		extension_len = max(0.0, extension_len - 8.0 * delta * max_extenstion)

	if grabbing_L and grabbing_timer_L > 0.0:
		print("PULL!")
		playerbody.apply_central_force(playerbody.position.direction_to(arm_pin_L) * 800.0)
		grabbing_timer_L -= delta
		playerbody.apply_central_force(x_bonus_dir * 200.0)

	if Input.is_action_just_pressed("explode") and bomb_timer.is_stopped():
		var explosion = bomb_explosion_particles.instantiate()
		explosion.position = bomb.global_position
		add_child(explosion)
		bomb.visible = false
		bomb_timer.start()
		bomb_explosion_player.play()
		playerbody.apply_central_impulse(-bomb.position.normalized() * 800.0)

	var direction = Input.get_axis("walk_left", "walk_right")
	if direction:
		playerbody.apply_central_force ( Vector2(direction * SPEED, 0.0) )

	bomb.position = playerbody.position.direction_to(get_global_mouse_position()) * 30.0
	arm.position = playerbody.position + playerbody.position.direction_to(get_global_mouse_position()) * 30.0
	arm.rotation = playerbody.position.direction_to(arm.position).angle()
	grab_area_L.position.x = extension_len

func _physics_process(delta):
	pass

func _integrate_forces(state):
	pass

func _on_area_2d_body_entered(body):
	print("entered")
	grabbing_L = true
	grabbing_timer_L = 0.75
	arm_pin_L = grab_area_collision_L.global_position
	$lastpin.position = arm_pin_L
	if playerbody.position.x < arm_pin_L.x:
		x_bonus_dir = Vector2.RIGHT
	elif playerbody.position.x > arm_pin_L.x:
		x_bonus_dir = Vector2.LEFT
	else:
		x_bonus_dir = Vector2.ZERO

func _on_area_2d_body_exited(body):
	pass

func _on_bomb_cooldown_timeout():
	bomb.visible = true
