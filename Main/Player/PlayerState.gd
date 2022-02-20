extends Node
class_name PlayerState

# Maximum health, cannot heal more than that
var max_health: int = 10

# Current health. Game over if reach 0
var health: int = 10


# 1=100% normal size
var bullet_size = 1.0

var bullet_range = 50

# 100% of speed
var speed = 1.0

# 1, 3, 5, 7
var nb_shot = 1

var piercing_bullets = false

var max_speed = 400.0


var has_turret = false
var turret_bullet = 0


# 0.05 = 5% of chance to get one hp on kill asteroid.
var vampire_rate = 0.0

var has_counterzone = false
