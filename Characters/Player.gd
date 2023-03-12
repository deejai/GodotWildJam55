extends RigidBody2D

const SPEED = 80.0
const JUMP_VELOCITY = -400.0

@onready var groundcast: RayCast2D = $GroundCast
@onready var walk_impulse_cd: Timer = $WalkImpulseCD

@onready var body: Node2D = $Body
@onready var hand_R: Node2D = $Hand_R
@onready var hand_L: Node2D = $Hand_L
@onready var grab_area_R: Area2D = $Hand_R/Area2D
@onready var grab_area_collision_R: CollisionShape2D = $Hand_R/Area2D/CollisionShape2D
@onready var grab_cd_R: Timer = $Grab_CD_R
@onready var grab_cd_L: Timer = $Grab_CD_L
@onready var grapple_pin_R: Vector2

@onready var bomb_timer: Timer = $Body/BombCooldown
@onready var bomb: Sprite2D = $Body/BombSprite
@onready var bomb_explosion_particles: PackedScene = load("res://Particles/ExplodeMove.tscn")
@onready var explode_move_player: AudioStreamPlayer2D = $ExplodeMovePlayer

@onready var sand: PackedScene = load("res://Particles/SandThrow.tscn")

@onready var rope_shoot_player: AudioStreamPlayer2D = $RopeShootPlayer
@onready var rope_dud_player: AudioStreamPlayer2D = $RopeDudPlayer
@onready var ropecast: RayCast2D = $RopeCast
var dudrope: PackedScene = load("res://Objects/DudRope.tscn")
var rope: PackedScene = load("res://Objects/Rope.tscn")

var explode_move_velocity: Vector2 = Vector2.ZERO

var max_extenstion: float = 150.0
var extension_len: float = 0.0
var grabbing_R: bool = false
var grabbing_L: bool = false
var x_bonus_dir: Vector2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _process(delta):
	var mouse_pos: Vector2 = get_global_mouse_position()
	var dir_to_mouse: Vector2 = position.direction_to(mouse_pos)
	ropecast.rotation = dir_to_mouse.angle()
	if not grabbing_L and mouse_pos.x < position.x:
		var pos_to = position.direction_to(mouse_pos) * 30.0
		hand_L.position = Vector2(min(pos_to.x, -15.0), pos_to.y)
		
		if Input.is_action_just_pressed("shoot_rope"):
			grabbing_L = true
			grab_cd_L.start()
			shoot_rope(hand_L)

	if not grabbing_R and mouse_pos.x >= position.x:
		var pos_to = dir_to_mouse * 30.0
		hand_R.position = Vector2(max(15.0, pos_to.x), pos_to.y)
		
		if Input.is_action_just_pressed("shoot_rope"):
			grabbing_R = true
			grab_cd_R.start()
			shoot_rope(hand_R)

	if Input.is_action_just_pressed("explode") and bomb_timer.is_stopped():
		var explosion = bomb_explosion_particles.instantiate()
		explosion.position = bomb.global_position
		get_parent().add_child(explosion)
		bomb.visible = false
		bomb_timer.start()
		explode_move_player.play()
		apply_central_impulse(-bomb.position.normalized() * 800.0)

	if Input.is_action_just_pressed("throw"):
		var new_sand = sand.instantiate()
		new_sand.position = dir_to_mouse * 20.0
		new_sand.rotation = dir_to_mouse.angle()
		add_child(new_sand)

	var direction = Input.get_axis("walk_left", "walk_right")
	if direction:
		if groundcast.is_colliding():
			if walk_impulse_cd.is_stopped():
				apply_central_impulse(Vector2(direction * SPEED, -100.0))
				walk_impulse_cd.start()
		else:
			apply_central_force(Vector2(direction * SPEED, 0.0))
 
	bomb.position = dir_to_mouse * 30.0
	queue_redraw()

func _physics_process(delta):
	pass

func _integrate_forces(state):
	pass

func _draw():
	if ropecast.get_collider() is Grabbable:
		var is_right: bool = get_global_mouse_position().x > position.x
		if (is_right and not grabbing_R) or (not is_right and not grabbing_L):
			var origin_pos: Vector2 = hand_R.position if is_right else hand_L.position
			draw_line(origin_pos, ropecast.get_collision_point() - position, Color(1, 1, 1, 0.2))

func _on_area_2d_body_entered(body):
	pass

func _on_area_2d_body_exited(body):
	pass

func _on_bomb_cooldown_timeout():
	bomb.visible = true

func _on_grab_cd_l_timeout():
	grabbing_L = false

func _on_grab_cd_r_timeout():
	grabbing_R = false

func shoot_rope(hand: Node2D):
	var rope_target = ropecast.get_collider()
	if rope_target is Grabbable:
		var new_rope: Rope = rope.instantiate()
		new_rope.anchor_point = ropecast.get_collision_point()
		new_rope.dangle_body = self
		new_rope.draw_to = hand
		get_parent().add_child(new_rope)
		rope_shoot_player.play()
	else:
		var dud = dudrope.instantiate()
		dud.position = hand.global_position + Vector2.RIGHT.rotated(ropecast.rotation) * 30.0
		dud.linear_velocity = Vector2.RIGHT.rotated(ropecast.rotation) * 100.0
		dud.rotation = ropecast.rotation
		get_parent().add_child(dud)
		rope_dud_player.play()
