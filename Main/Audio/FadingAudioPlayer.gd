extends AudioStreamPlayer


onready var tween_in = $TweenIn
onready var tween_out = $TweenOut

export var transition_duration = 1.00
export var transition_type = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func play_sound():
	tween_in.interpolate_property(self, "volume_db", -80, 0, transition_duration, transition_type)
	tween_in.start()
	tween_out.stop_all()
	play()
	
	
func stop_sound():
	tween_out.interpolate_property(self, "volume_db", 0, -80, transition_duration, transition_type)
	tween_out.start()


func _on_TweenOut_tween_completed(object, key):
	object.stop()


func _on_Timer_timeout():
	play_sound()
	$Timer2.start()


func _on_Timer2_timeout():
	stop_sound()
