extends Node2D


var explosion_scene = load("res://Main/ExplosionParticle.tscn")

signal Hit
# choose the direction of the snake
var is_head = true

var total_parts = 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
onready var previous_position = global_position
var offset = Vector2.ZERO


var colors = [
	"F8B195",
	"D6F8B8",
	"9AB5C1",
	"EBEDC8",
	"C1867B",
	"6C567B"
]

var container = null

func _ready():
	
	container = get_tree().get_nodes_in_group("Container")[0]
	randomize()
	var color = Color(colors[randi()%colors.size()])
	modulate = color

func get_next_spawn_pos():
	return $Bottom.global_position+$Bottom.position

onready var size = $Top.position.distance_to($Bottom.position)

func hit(bullet: Node2D):
	var explosion: Node2D = explosion_scene.instance()
	container.add_child(explosion)
	explosion.global_position = global_position
	explosion.modulate = modulate

	emit_signal("Hit", self)
