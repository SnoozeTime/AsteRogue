extends KinematicBody2D

var target: Node2D = null

var explosion_scene = load("res://Main/ExplosionParticle.tscn")
var speed = 200
var velocity = Vector2.ZERO

var bullet_scene = load("res://Main/Bullet.tscn")
var container: Node2D = null
var other_enemies = []
signal Died

var health = 1.0
var invincibility_frames = 5

func _ready():
	if GameState.ng>0:
		health += 1
	target = get_tree().get_nodes_in_group("Player")[0]
	container = get_tree().get_nodes_in_group("Container")[0]
	other_enemies = get_tree().get_nodes_in_group("Enemy")
	

func _physics_process(delta):
	invincibility_frames -= 1
	var dir = Vector2.ZERO
	var dir_to_player = global_position.direction_to(target.global_position)
	if global_position.distance_to(target.global_position) > 200:
		if velocity == Vector2.ZERO:
			dir = dir_to_player
		else:
			dir = (2*dir_to_player+velocity.normalized())/3.0
			
			
	for enemy in other_enemies:
		if enemy != self and enemy != null:
			if enemy.global_position.distance_to(global_position) < 100:
				dir += 0.5*-global_position.direction_to(enemy.global_position)
				dir = dir.normalized()
	
	velocity = velocity.linear_interpolate(dir*speed, delta)
	move_and_slide(velocity)

	

	global_position.x = wrapf(global_position.x, 0, 1024)
	global_position.y = wrapf(global_position.y, 0, 600)


func _on_ShootTimer_timeout():
	shoot()



func shoot():
	$ShootSound.play()
	var bullet = bullet_scene.instance()
	bullet.dir = global_position.direction_to(target.global_position)
	container.add_child(bullet)
	
	bullet.set_enemy_bullet()
	bullet.global_position = global_position

func hit(bullet: Node2D):
	call_deferred("boum")


func boum():
	if invincibility_frames>0:
		return
	health -= 1
	invincibility_frames = 5
	if health == 0:
		var explosion: Node2D = explosion_scene.instance()
		container.add_child(explosion)
		explosion.global_position = global_position
		explosion.modulate = modulate

		call_deferred("queue_free")
		emit_signal("Died")
	else:
		$AnimationPlayer.play("Hit")
