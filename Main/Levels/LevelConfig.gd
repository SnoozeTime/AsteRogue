extends Node


var level_descs = [
	# FIRST LVL
	{
		"waves": [
			{
				"wave_duration": 10,
				"enemies":  [EnemyType.Asteroid]
			},
			{
				"wave_duration": 10,
				"enemies":  [EnemyType.Asteroid, EnemyType.Asteroid, EnemyType.Asteroid]
			}
		]
	},
	# SECOND LVL
	{
		"waves": [
			{
				"wave_duration": 3,
				"enemies":  [EnemyType.Asteroid, EnemyType.Asteroid]
			},
			{
				"wave_duration": 10,
				"enemies": [EnemyType.Saucer]
			},
			{
				"wave_duration": 10,
				"enemies":  [EnemyType.Asteroid, EnemyType.Asteroid, EnemyType.Asteroid, EnemyType.Saucer, EnemyType.Saucer]
			}
		]
	},
	# THIRD LVL
	{
		"waves": [
			{
				"wave_duration": 10,
				"enemies":  [EnemyType.Snake]
			},
			{
				"wave_duration": 10,
				"enemies": [EnemyType.Snake, EnemyType.Asteroid, EnemyType.Asteroid]
			},
			{
				"wave_duration": 5,
				"enemies":  [EnemyType.Asteroid, EnemyType.Snake, EnemyType.Asteroid, EnemyType.Saucer]
			},
			{
				"wave_duration": 10,
				"enemies": [EnemyType.Saucer]
			}
		]
	},
	{
		"waves": [
			{
				"wave_duration": 2,
				"enemies":  [EnemyType.Asteroid]
			},
			{
				"wave_duration": 3,
				"enemies":  [EnemyType.Asteroid,EnemyType.Asteroid, EnemyType.Asteroid]
			},
			{
				"wave_duration": 4,
				"enemies":  [EnemyType.Asteroid,EnemyType.Asteroid, EnemyType.Asteroid, EnemyType.Asteroid]
			},
			{
				"wave_duration": 4,
				"enemies":  [EnemyType.Asteroid,EnemyType.Asteroid, EnemyType.Asteroid, EnemyType.Asteroid, EnemyType.Asteroid, EnemyType.Asteroid]
			}
		],
		
	},
	{
		"waves": [
			{
				"wave_duration": 2,
				"enemies":  [EnemyType.Saucer]
			},
			{
				"wave_duration": 3,
				"enemies":  [EnemyType.Saucer,EnemyType.Saucer]
			},
			{
				"wave_duration": 10,
				"enemies":  [EnemyType.Saucer,EnemyType.Asteroid, EnemyType.Asteroid, EnemyType.Asteroid]
			},
			{
				"wave_duration": 4,
				"enemies":  [EnemyType.Saucer,EnemyType.Saucer, EnemyType.Saucer, EnemyType.Saucer]
			}
		]
	},
	{
		"waves": [
			{
				"wave_duration": 5,
				"enemies":  [EnemyType.Asteroid,EnemyType.Asteroid, EnemyType.Asteroid, EnemyType.Asteroid]
			},
			{
				"wave_duration": 10,
				"enemies":  [EnemyType.Snake,EnemyType.Saucer]
			},
			{
				"wave_duration": 5,
				"enemies":  [EnemyType.Asteroid,EnemyType.Asteroid, EnemyType.Asteroid, EnemyType.Asteroid]
			},
			{
				"wave_duration": 3,
				"enemies":  [EnemyType.Snake,EnemyType.Saucer]
			},
			{
				"wave_duration": 10,
				"enemies":  [EnemyType.Asteroid]
			},
			{
				"wave_duration": 2,
				"enemies":  [EnemyType.Asteroid,EnemyType.Asteroid,EnemyType.Asteroid,EnemyType.Asteroid,EnemyType.Asteroid]
			}
		]
	}
]

enum EnemyType {
	Saucer,
	Asteroid,
	Snake
}

var levels = create_levels()

func create_levels():
	var l = []
	for desc in level_descs:
		l.append(create_lvl_from_desc(desc))
	return l

func create_lvl_from_desc(desc):

	var waves_desc = desc["waves"]

	var l = Level.new()
	for wave_desc in waves_desc:
		var wave = Wave.new()
		wave.enemies = wave_desc["enemies"]
		wave.wave_duration = wave_desc["wave_duration"]
		l.waves.append(wave)
	return l

func get_level_by_idx(i):
	return levels[i]
