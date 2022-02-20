extends RigidBody2D


signal PlayerDead
signal HealthUpdate

export var torque: float = 3.0
var speed = 20.0

var state: PlayerState = GameState.current_player_state

var bullet_scene = load("res://Main/Bullet.tscn")
var container: Node2D = null
var shoot_angles = []
var turret_scene = load("res://Main/Turret.tscn")
var explosion_scene = load("res://Main/ExplosionParticle.tscn")
var rng = RandomNumberGenerator.new()

var alive = true
var zone_scene = load("res://Main/Attacks/Zone.tscn")

func _ready():
	rng.randomize()
	container = get_tree().get_nodes_in_group("Container")[0]
	shoot_angles = get_shoot_angles()
	if state.has_turret:
		var turret: Node2D = turret_scene.instance()
		$TurretLoc.add_child(turret)
		turret.scale *= 0.2

func _integrate_forces(physic_state):
	if physic_state.linear_velocity.length() > state.max_speed:
		physic_state.linear_velocity = physic_state.linear_velocity.normalized() * state.max_speed

func _physics_process(delta):
	
	if is_dead():
		return

	if Input.is_action_pressed("Thrust"):
		apply_central_impulse(Vector2.UP.rotated(rotation) * speed * state.speed)
	elif Input.is_action_pressed("Brake"):
		apply_central_impulse(Vector2.DOWN.rotated(rotation) * speed* state.speed)
		
	if Input.is_action_just_pressed("Thrust"):
		$FadingAudioPlayer.play_sound()
	elif Input.is_action_just_released("Thrust"):
		$FadingAudioPlayer.stop()
		
	if Input.is_action_pressed("Left"):
		rotation_degrees -= torque
	elif Input.is_action_pressed("Right"):
		rotation_degrees += torque
			
	if Input.is_action_just_pressed("Shoot"):
		shoot()
	

	global_position.x = wrapf(global_position.x, 0, 1024)
	global_position.y = wrapf(global_position.y, 0, 600)

func is_dead():
	return not alive

func shoot():
	for angle in shoot_angles:
		var bullet = bullet_scene.instance()
		bullet.dir = Vector2.UP.rotated(rotation).rotated(deg2rad(angle))
		bullet.scale *= state.bullet_size
		bullet.lifetime = state.bullet_range
		bullet.piercing = state.piercing_bullets
		container.add_child(bullet)
		bullet.global_position = $Gun.global_position
	$ShootSound.play()

func get_shoot_angles():
	var nb_bullets = state.nb_shot
	var the_range = (nb_bullets-1)*15.0
	if nb_bullets == 1:
		return [0]
	else:
		var angle_between_bullets = the_range / (nb_bullets - 1)
		var angles = []
		for i in range(nb_bullets):
			angles.append(-(the_range/2.0)+angle_between_bullets*i)
		return angles

func hit(body):
	call_deferred("on_hit")
	
func on_hit():
	if is_dead():
		return

	$AnimationPlayer.play("GotHit")
	
	var damage = 1
	if GameState.ng >= 2:
		damage = 2
	state.health -= damage
	emit_signal("HealthUpdate")
	if state.health <= 0:
		var explosion = explosion_scene.instance()
		container.add_child(explosion)
		explosion.scale*=2
		explosion.global_position = global_position
		alive = false
		$CollisionPolygon2D.set_deferred("disabled", true)
		$Sprite.hide()
		emit_signal("PlayerDead")
	else:
		$AnimationPlayer.play("GotHit")
		
		
	if state.has_counterzone:
		var zone = zone_scene.instance()
		container.add_child(zone)
		zone.global_position = global_position


func on_enemy_died():
	if rng.randf() < state.vampire_rate:
		state.health = min(state.health+1, state.max_health)
		emit_signal("HealthUpdate")


func _on_Player_body_entered(body):

	call_deferred("on_hit")
