extends Node2D


export var parts = 15


var snake_part = load("res://Main/Enemies/SnakePart.tscn")
var snake_scene = load("res://Main/Enemies/Snake.tscn")
var current_dir = Vector2.RIGHT

var snake_positions = []
var tick_time = 0.3 # one sec
var elapsed = tick_time


var container: Node2D = null
signal Died
signal SnakePartDied

func _ready():
	$DirectionTimer.start(randi() % 5)
	container = get_tree().get_nodes_in_group("Container")[0]
	
func instance_parts(start_point):

	var pos = start_point
	for i in range(parts):
		var part: Node2D = snake_part.instance()
		$parts.add_child(part)
		part.connect("Hit", self, "on_hit")
		part.global_position = pos
		snake_positions.append(pos)
		pos = part.get_next_spawn_pos()
		
func on_hit(part: Node2D):
	emit_signal("SnakePartDied")
	# if only one part in the snake, let's no overcomplicate;
	if $parts.get_child_count() == 1:
		call_deferred("queue_free")
		emit_signal("Died")
	else:
		
		# Two corner cases. Part is first or part is last
		if part == $parts.get_child(0) or part == $parts.get_child($parts.get_child_count()-1):
			$parts.remove_child(part)
			part.call_deferred("queue_free")
			sync_positions()
		else:
			# Separate the snake in two...
			var parts_before = []
			var parts_after = []
			var has_met_part = false
			for i in range($parts.get_child_count()):
				var child = $parts.get_child(i)
				child.disconnect("Hit", self, "on_hit")
				if part == child:
					has_met_part = true
				elif has_met_part:
					parts_after.append(child)
				else:
					parts_before.append(child)
			
			for c in $parts.get_children():
				$parts.remove_child(c)
			part.call_deferred("queue_free")
			
			#bouuuuuh
			var game_node = get_parent().get_parent()
			# NEW SNAKES !
			if len(parts_before) > 1:
				var new_snake: Node2D = snake_scene.instance()
				container.add_child(new_snake)
				new_snake.call_deferred("add_all_parts", parts_before)
				new_snake.connect("Died", game_node, "_on_Enemy_death")
				new_snake.connect("SnakePartDied", game_node, "_on_SnakePart_Died")
			
			if len(parts_after) > 1:
				var new_snake2: Node2D = snake_scene.instance()
				container.add_child(new_snake2)
				new_snake2.call_deferred("add_all_parts", parts_after)
				new_snake2.connect("Died", game_node, "_on_Enemy_death")
				new_snake2.connect("SnakePartDied", game_node, "_on_SnakePart_Died")
func add_all_parts(parts):
	for p in parts:
		p.connect("Hit", self, "on_hit")
		$parts.add_child(p)
	sync_positions()

func sync_positions():
	snake_positions = []
	for part in $parts.get_children():
		snake_positions.append(part.global_position)

func _process(delta):
	
	elapsed -= delta
	if elapsed < 0:
		move_snake()		
		elapsed = tick_time
		
	if $parts.get_child_count() == 0:
		call_deferred("queue_free")

func move_snake():

	for j in range($parts.get_child_count(), 0, -1):
		var i = j - 1
		var part = $parts.get_child(i)
		if i == 0:
			part.global_position += current_dir*part.size
			

			part.global_position.x = wrapf(part.global_position.x, 0, 1024)
			part.global_position.y = wrapf(part.global_position.y, 0, 600)
		else:
			# Children will just get the previous pos of the node above.
			part.global_position = snake_positions[i-1]
		snake_positions[i] = part.global_position
	
func check_dir():
	var head: Node2D = $parts.get_child(0)
	match current_dir:
		Vector2.RIGHT:
			if head.global_position.x > 950:
				current_dir = Vector2.LEFT
		Vector2.UP:
			if head.global_position.y < 50:
				current_dir = Vector2.DOWN
		Vector2.LEFT:
			if head.global_position.x < 50:
				current_dir = Vector2.RIGHT
		Vector2.DOWN:
			if head.global_position.y > 550:
				current_dir = Vector2.UP

func change_dir():
	var rand_dir = randi()%2
	if current_dir.x != 0:
		match rand_dir:
			0:
				current_dir = Vector2.DOWN
			1:
				current_dir = Vector2.UP
	else:
		match rand_dir:
			0:
				current_dir = Vector2.LEFT
			1:
				current_dir = Vector2.RIGHT

func _on_DirectionTimer_timeout():
	change_dir()
	$DirectionTimer.start(randi() % 5)
