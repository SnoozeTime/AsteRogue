extends Node2D


var asteroid_scene = load("res://Main/Asteroid.tscn")
var rng = RandomNumberGenerator.new()


var top_screen = load("res://Main/GUI/TopScreen.tscn").instance()
var setting_screen = load("res://Main/GUI/ControlsScreen.tscn").instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	add_asteroids()
	$CanvasLayer.add_child(top_screen)
	top_screen.connect("GoSettings", self, "OnGoSettings")
	setting_screen.connect("GoToTop", self, "OnGoTop")
	SavedData.load_game()

func OnGoSettings():
	remove_screen()
	$CanvasLayer.add_child(setting_screen)

func OnGoTop():
	remove_screen()
	$CanvasLayer.add_child(top_screen)
	
func remove_screen():
	var screen = $CanvasLayer.get_child(0)
	$CanvasLayer.remove_child(screen)

func add_asteroids():
	for i in range(10):
		
		var pos = Vector2(rng.randf_range(0, 1024), rng.randf_range(0, 600))
		var asteroid = asteroid_scene.instance()
		$Container.add_child(asteroid)
		asteroid.init(rng)
		asteroid.global_position = pos
