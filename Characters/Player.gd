extends RigidBody2D

class_name Player

const WALK_SPEED = 180.0
const JUMP_VELOCITY = -400.0

@onready var groundcasts: Array = $GroundCasts.get_children()
@onready var walk_impulse_cd: Timer = $WalkImpulseCD
var grounded: bool = false

@onready var body: Node2D = $Body
@onready var hand_R: Node2D = $Hand_R
@onready var hand_L: Node2D = $Hand_L
@onready var legs: Node2D = $Legs

@onready var head_sprite: Sprite2D = $Head/Sprite2D
@onready var body_sprite: Sprite2D = $Body/Sprite2D
@onready var legs_sprite: AnimatedSprite2D = $Legs/AnimatedSprite2D

@onready var grab_cd_R: Timer = $Grab_CD_R
@onready var grab_cd_L: Timer = $Grab_CD_L
@onready var grapple_pin_R: Vector2

@onready var explode_move_timer: Timer = $Body/ExplodeMoveCooldown
@onready var explode_move_arrow: Sprite2D = $Body/ExplodeMoveArrow
@onready var explode_move_explosion_particles: PackedScene = load("res://Particles/ExplodeMove.tscn")
@onready var explode_move_player: AudioStreamPlayer2D = $ExplodeMovePlayer

@onready var sand_projectile: PackedScene = load("res://Objects/SandThrowProjectile.tscn")

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

@onready var breaking_speed_timer: Timer = $BreakingSpeedTimer
var breaking_speed: bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	legs_sprite.play()

func _process(delta):
	queue_redraw()
	if linear_velocity.length() > 1050.0:
		breaking_speed = true
		breaking_speed_timer.start()

	grounded = false
	for groundcast in groundcasts:
		if groundcast.is_colliding():
			grounded = true
			break

	if not walk_impulse_cd.is_stopped():
		legs_sprite.animation = "walk"
	elif grounded:
		legs_sprite.animation = "idle"
	else:
		legs_sprite.animation = "airborne"

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

	if Input.is_action_just_pressed("explode") and explode_move_timer.is_stopped():
		var explosion = explode_move_explosion_particles.instantiate()
		explosion.position = position - dir_to_mouse * 30.0
		get_parent().add_child(explosion)
		explode_move_arrow.visible = false
		explode_move_timer.start()
		explode_move_player.play()
		apply_central_impulse(dir_to_mouse * 600.0)

	if Input.is_action_just_pressed("throw"):
		var new_sand_proj = sand_projectile.instantiate()
		new_sand_proj.position = position + dir_to_mouse * 20.0
		new_sand_proj.rotation = dir_to_mouse.angle()
		new_sand_proj.bonus_velocity = Vector2(linear_velocity.x, 0.0).limit_length(450.0) if dir_to_mouse.x * linear_velocity.x > 0.0 else Vector2.ZERO
		get_parent().add_child(new_sand_proj)

	var flip_sprites: bool = dir_to_mouse.x < 0.0
	legs_sprite.flip_h = flip_sprites
	body_sprite.flip_h = flip_sprites
	head_sprite.flip_h = flip_sprites

	var direction = Input.get_axis("walk_left", "walk_right")
	if direction:
		if grounded:
			if walk_impulse_cd.is_stopped():
				apply_central_impulse(Vector2(direction * WALK_SPEED, -100.0))
				walk_impulse_cd.start()
		else:
			apply_central_force(Vector2(direction * WALK_SPEED, 0.0))
 
	explode_move_arrow.position = dir_to_mouse * 60.0
	explode_move_arrow.rotation = dir_to_mouse.angle()
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
			
	if breaking_speed:
		draw_circle(Vector2.ZERO, 50.0, Color.RED)

func _on_area_2d_body_entered(body):
	pass

func _on_area_2d_body_exited(body):
	pass

func _on_explode_move_cooldown_timeout():
	explode_move_arrow.visible = true

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
		dud.position = hand.global_position + Vector2.RIGHT.rotated(ropecast.rotation) * 5.0
		dud.linear_velocity = Vector2.RIGHT.rotated(ropecast.rotation) * 500.0
		
		# if moving in same direction as shooting, boost horizontal speed
		if linear_velocity.x * dud.position.x > 0.0:
			dud.linear_velocity.x += linear_velocity.x

		dud.rotation = ropecast.rotation
		get_parent().add_child(dud)
		rope_dud_player.play()


func _on_breaking_speed_timer_timeout():
	breaking_speed = false
