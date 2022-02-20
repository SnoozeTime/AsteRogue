extends Node2D

var time_left = 20.0

func _process(delta):
	time_left -= delta

	if time_left < 5.0:
		$AnimationPlayer.play("BlingFast")
		
	if time_left < 0:
		queue_free()


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		get_node("/root/Game").pick_gold()
		call_deferred("queue_free")
