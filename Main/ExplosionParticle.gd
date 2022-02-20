extends CPUParticles2D


func _ready():
	emitting = true

func _on_DeathTimer_timeout():
	call_deferred("queue_free")
