extends Area2D


var speed = 10
var dir = Vector2.RIGHT
var lifetime = 50
var piercing = false

	
func set_enemy_bullet():
	set_collision_mask_bit(0, true)
	set_collision_mask_bit(1, false)
	set_collision_layer_bit(5, true)
	set_collision_layer_bit(2, false)
	$Sprite.modulate = Color(1.2, 1, 1)
	speed = 5
	lifetime = 200

func _physics_process(delta):
	translate(dir*speed)

	lifetime -= 1
	global_position.x = wrapf(global_position.x, 0, 1024)
	global_position.y = wrapf(global_position.y, 0, 600)

	if lifetime == 0:
		queue_free()



func _on_Bullet_body_entered(body):
	if body.has_method("hit"):
		body.hit(self)
	if not piercing:
		call_deferred("queue_free")
