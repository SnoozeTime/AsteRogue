extends KinematicBody2D


var direction: Vector2 = Vector2.RIGHT

var max_speed = 100.0
var velocity: Vector2 = Vector2.ZERO

var level = 0
var max_level = 2
# Because otherwise, piercing bullets reckts asteroids.
var invincibility_frames = 5


# If true, then will drop gold on death. Only level 2 asteroids drop gold,
# so gold will be passed to one if the children.
var has_gold = false
# Emit on death to spawn some gold at the place of death
signal SpawnGold(pos)
signal Died

var container: Node2D = null

var asteroid = load("res://Main/Asteroid.tscn")
var explosion_scene = load("res://Main/ExplosionParticle.tscn")
var gold_scene = load("res://Main/Gold.tscn")

func _ready():
	randomize()
	rotation = randf() * 2 * PI
	max_speed = randi()%150 + 50
	container = get_tree().get_nodes_in_group("Container")[0]
	
func init(rng):
	var angle = rng.randf() * 2 * PI
	direction = Vector2.RIGHT.rotated(angle)
	
func can_be_touched() -> bool:
	return invincibility_frames < 0

func _physics_process(delta):
	invincibility_frames -= 1
	velocity = velocity.linear_interpolate(direction * max_speed, delta)
	#move_and_slide(velocity)
	
	var collision = move_and_collide(velocity*delta, false)

	if collision != null:
		if collision.collider.has_method("hit"):
			collision.collider.hit(self)
		call_deferred("boum")

	global_position.x = wrapf(global_position.x, 0, 1024)
	global_position.y = wrapf(global_position.y, 0, 600)

func hit(bullet: Node2D):
	call_deferred("boum")


func boum():
	if not can_be_touched():
		return

	if level != max_level:
		var n1: Node2D = asteroid.instance()
		n1.direction = velocity.normalized().rotated(deg2rad(45))
		n1.level = level + 1
		n1.velocity = velocity
		n1.scale /= 2 * n1.level
		var n2: Node2D = asteroid.instance()
		n2.direction = velocity.normalized().rotated(deg2rad(-45))
		n1.velocity = velocity
		n2.level = level + 1
		n2.scale /= 2 * n2.level
		
		if has_gold:
			if randi() % 2 == 0:
				n1.has_gold = true
			else:
				n2.has_gold = true
		container.add_child(n1)
		container.add_child(n2)

		# No ideal maybe
		n1.connect("Died", get_parent().get_parent(), "_on_Enemy_death")
		n2.connect("Died", get_parent().get_parent(), "_on_Enemy_death")
		
		n1.global_position = global_position
		n2.global_position = global_position
	else:
		if has_gold:
			var gold = gold_scene.instance()
			container.add_child(gold)
			gold.global_position = global_position
	emit_signal("Died")

	var explosion = explosion_scene.instance()
	container.add_child(explosion)
	explosion.global_position = global_position
	call_deferred("queue_free")
