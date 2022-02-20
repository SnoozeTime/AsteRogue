extends Node2D

var target: Node2D = null


var bullet_scene = load("res://Main/Bullet.tscn")
var container: Node2D = null

func _ready():
	container = get_tree().get_nodes_in_group("Container")[0]




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if target != null:
		var angle = global_position.angle_to_point(target.global_position)
		$Canon.global_rotation = angle+PI
		


func _on_AcquireTarget_timeout():
	acquire_new_target()


func _on_ShootTimer_timeout():
	if target != null:
		shoot()
		
func acquire_new_target():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	if len(enemies) > 0:
		target = enemies[0]
		if target.is_in_group("Snake"):
			target = target.get_node("parts").get_child(0)
func shoot():
	for i in range(GameState.current_player_state.turret_bullet):
		shoot_once()	
		yield(get_tree().create_timer(0.3), "timeout")


func shoot_once():
	if target == null:
		acquire_new_target()
	if target != null:
		var bullet = bullet_scene.instance()
		bullet.dir = global_position.direction_to(target.global_position)
		container.add_child(bullet)
		bullet.global_position = global_position
		$ShootSound.play()
