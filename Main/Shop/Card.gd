extends TextureButton

export var is_turret = false
export var is_counterzone = false
export var base_gold_value = 2
var gold_value = base_gold_value
var already_bought = false


func _ready():
	gold_value = base_gold_value * (2*GameState.ng+1)

	$GoldContainer/GoldLabel.text = str(gold_value)

func _physics_process(delta):
	if not can_buy():
		set_cannot_buy()

func set_cannot_buy():
	modulate = Color("#707070")

func can_buy() -> bool:
	return GameState.gold >= gold_value and not already_bought

func _on_Card_mouse_entered():
	if can_buy():
		$AnimationPlayer.play("Hovered")
		


func _on_Card_mouse_exited():
	$AnimationPlayer.play("Idle")

func apply():
	if can_buy():
		$Behavior.exec(GameState.current_player_state)
		set_cannot_buy()
		already_bought = true
		GameState.gold -= gold_value
