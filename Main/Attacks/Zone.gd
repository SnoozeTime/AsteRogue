extends Node2D

var lifetime = 0.3 # in seconds

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lifetime -= delta
	if lifetime<0:
		queue_free()


func _on_Area2D_body_entered(body):
	if body.has_method("hit"):
		body.hit(self)
