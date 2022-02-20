extends Node2D

var rng = RandomNumberGenerator.new()

var asteroid_scene = load("res://Main/Asteroid.tscn")
var saucer_scene = load("res://Main/Enemies/Saucer.tscn")
var snake_scene = load("res://Main/Enemies/Snake.tscn")

enum State {
	Loading, # Loading level
	Waiting, # waiting for wave to instantiate.
	Fighting,
	Done,
	GameOver
}

var state = State.Loading

var time_to_wait = 3.0 # three seconds before spawning wave.

var current_level: Level = null
var current_wave = 0
var time_on = true

var wave_duration = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()

	$GUILayer/HealthLabel.text = "HP: %s/%s" % [$Player.state.health, $Player.state.max_health]
	$GUILayer/LevelLabel.text = "Level: %s/6" % (GameState.current_level_id+1)
	if GameState.ng > 0:	
		$GUILayer/LevelLabel.text = "NG+%s: %s/6" % [GameState.ng, (GameState.current_level_id+1)]
		
	
	$GameMusic.pitch_scale = rand_range(0.8, 1.2)
	$GameMusic.play()

func pick_gold():
	$Sound/MoneySound.play()
	GameState.gold += 1


func gui_timer():
	var minutes = int(GameState.total_time/60.0)
	var seconds = GameState.total_time-minutes*60
	$GUILayer/TimeLabel.text = "%sm%ss" % [minutes, stepify(seconds, 0.1)]
	

func _process(delta):
		
	if Input.is_action_just_pressed("Pause"):
		get_tree().paused = true
		$GUILayer/PauseScene.pause()
	
	gui_timer()
	if time_on:
		GameState.total_time += delta
	
	match state:
		State.Loading:
			init_level()
		State.Waiting:
			time_to_wait -= delta
			if time_to_wait <= 0:
				state = State.Fighting
				var w = current_level.waves[current_wave]
				spawn_wave(w)
		State.Fighting:
			handle_snake_sound()
			wave_duration -= delta
			if is_last_wave():
				var enemies = get_tree().get_nodes_in_group("Enemy")
				if len(enemies) == 0:
					state = State.Done
					time_on = false
					time_to_wait = 5.0
			else:
				if wave_duration < 0:
					# spawn next wave
					current_wave += 1
					var w = current_level.waves[current_wave]
					spawn_wave(w)
		State.Done:
			time_to_wait -= delta
			if time_to_wait <= 0:
				if GameState.is_last_level():
					GameState.victory = true	
					get_tree().change_scene("res://Main/GUI/GameOverScreen.tscn")
				else:
					GameState.current_level_id += 1
					get_tree().change_scene("res://Main/Shop.tscn")
		State.GameOver:
			time_to_wait -= delta
			if time_to_wait <= 0:
				get_tree().change_scene("res://Main/GUI/GameOverScreen.tscn")


func handle_snake_sound():
	var snakes = get_tree().get_nodes_in_group("Snake")
	if len(snakes) > 0 and not $Sound/SnakeSound.playing:
		$Sound/SnakeSound.play()
	elif len(snakes) == 0 and $Sound/SnakeSound.playing:
		$Sound/SnakeSound.stop()

func is_last_wave():
	return current_wave == len(current_level.waves)-1

func init_level():
	state = State.Waiting
	current_level = LevelConfig.get_level_by_idx(GameState.current_level_id)
	time_to_wait = 3.0

func spawn_wave(wave: Wave):
	wave_duration = wave.wave_duration
	for enemy in wave.enemies:
		
		var to_spawn = GameState.ng+1
		for i in range(to_spawn):
			var pos = Vector2(rand_range(0, 1024), rand_range(0, 600))

			# Give some distance from player to asteroid.
			while pos.distance_to($Player.global_position) < 100:
				pos = Vector2(rand_range(0, 1024), rand_range(0, 600))
			
			
			var enemy_node = null
			
			match enemy:
				LevelConfig.EnemyType.Asteroid:
					enemy_node = asteroid_scene.instance()
					enemy_node.init(rng)
					enemy_node.has_gold = true
				LevelConfig.EnemyType.Saucer:
					enemy_node = saucer_scene.instance()
				LevelConfig.EnemyType.Snake:
					enemy_node = snake_scene.instance()
			$Container.add_child(enemy_node)
			
			if enemy == LevelConfig.EnemyType.Snake:
				# So that the all snake does not start in the middle of the screen
				pos.y = 600
				enemy_node.instance_parts(pos)
				enemy_node.connect("SnakePartDied", self, "_on_SnakePart_Died")
				
			else:
				enemy_node.global_position = pos
			enemy_node.connect("Died", self, "_on_Enemy_death")

func _on_SnakePart_Died():
	$Sound/PartExplosion.play()


func _on_Enemy_death():
	$Sound/ExplosionSound.play()
	GameState.enemy_killed += 1
	$Player.on_enemy_died()


func _on_Player_HealthUpdate():
	$GUILayer/HealthLabel.text = "HP: %s/%s" % [$Player.state.health, $Player.state.max_health]


func _on_Player_PlayerDead():
	state = State.GameOver
	time_to_wait = 5.0
	time_on = false
	$GUILayer/TimeLabel.hide()
	$GUILayer/GameOverLabel.show()
	$GUILayer/HealthLabel.hide()


func _on_GameMusic_finished():
	yield(get_tree().create_timer(5), "timeout")
	$GameMusic.pitch_scale = rand_range(0.8, 1.2)
	$GameMusic.play()
