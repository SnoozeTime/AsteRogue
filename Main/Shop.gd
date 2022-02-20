extends Node2D


var stats_cards = [
	load("res://Main/Shop/MaxHealthCard.tscn"),
	load("res://Main/Shop/SpeedUpCard.tscn"),
	load("res://Main/Shop/SpeedDownCard.tscn"),
	load("res://Main/Shop/BiggerBulletCard.tscn")
]
var health_card = load("res://Main/Shop/HealthCard.tscn")

var upgrade_cards = [
	load("res://Main/Shop/MultishotCard.tscn"),
	load("res://Main/Shop/LifeStealCard.tscn"),
	load("res://Main/Shop/CounterExplosionCard.tscn"),
	load("res://Main/Shop/TurretCard.tscn")
]

onready var card_container = $CanvasLayer/MarginContainer/HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$CanvasLayer/GoldLabel.text = "Gold: %s" % GameState.gold
	remove_taken()
	add_cards()

func add_cards():
	
	var card1: Control = stats_cards[randi() % stats_cards.size()].instance()
	card_container.add_child(card1)
	card1.size_flags_horizontal = card1.SIZE_EXPAND_FILL
	card1.connect("pressed", self, "_on_First_pressed")
	
	card1.rect_scale = Vector2(.7, .7)
	
	var card2: Control = health_card.instance()
	card_container.add_child(card2)
	card2.size_flags_horizontal = card1.SIZE_EXPAND_FILL
	card2.connect("pressed", self, "_on_Second_pressed")
	
	var first_upgrade = randi() % upgrade_cards.size()
	
	
	var card3: Control = upgrade_cards[first_upgrade].instance()
	card_container.add_child(card3)
	card3.size_flags_horizontal = card1.SIZE_EXPAND_FILL
	card3.connect("pressed", self, "_on_Third_pressed")
	
	var second_upgrade = randi() % upgrade_cards.size()
	while first_upgrade == second_upgrade:
		second_upgrade = randi() % upgrade_cards.size()
	var card4: Control = upgrade_cards[second_upgrade].instance()
	card_container.add_child(card4)
	card4.connect("pressed", self, "_on_Fourth_pressed")


func _on_First_pressed():
	exec_card(0)
	
func _on_Second_pressed():
	exec_card(1)

func _on_Third_pressed():
	exec_card(2)
	
func _on_Fourth_pressed():
	exec_card(3)

func exec_card(i: int):
	var card = card_container.get_child(i)
	card.apply()
	update_gold()
	remove_taken()
func remove_taken():
	if GameState.current_player_state.has_counterzone:
		for i in range(len(upgrade_cards)):
			if upgrade_cards[i].resource_path == "res://Main/Shop/CounterExplosionCard.tscn":
				upgrade_cards.remove(i)
				break
func update_gold():
	$CanvasLayer/GoldLabel.text = "Gold: %s" % GameState.gold

func _on_ContinueButton_pressed():
	get_tree().change_scene("res://Main/Game.tscn")
