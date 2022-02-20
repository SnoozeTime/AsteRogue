extends HBoxContainer

signal start_editing()
signal finished_editing()

export(String, 
	"Thrust", 
	"Brake",
	"Left",
	"Right",
	"Shoot") var action_name = "Thrust"


const NICE_NAMES = {
	"Thrust": "Thrust",
	"Brake": "Brake",
	"Left": "Rotate Left",
	"Right": "Rotate Right",
	"Shoot": "Shoot"
}

var typing = false

var current_action

func _ready():
	$Label.text = action_name
	for action in InputMap.get_action_list(action_name):
		if action is InputEventKey:
			current_action = action
			$Button.text = OS.get_scancode_string(current_action.scancode)
			break
	
func _process(_delta):
	if Input.is_action_just_pressed("Pause"):
		if typing:
			stop_editing()

func _input(event):
	if event is InputEventKey and typing == true and event.is_pressed():
		
		if event.scancode != KEY_ESCAPE:
			var new_keycode = event.scancode			
			InputMap.action_erase_event(action_name, current_action)
			current_action.scancode = new_keycode
			InputMap.action_add_event(action_name, current_action)
			stop_editing()


func stop_editing():
	$Button.disabled = false
	$Button.text = OS.get_scancode_string(current_action.scancode)
	typing = false
	emit_signal("finished_editing", self)

func _on_Button_pressed():
	emit_signal("start_editing", self)

func edit():
	typing = true
	$Button.disabled = true
	$Button.text = "Type the key to assign"	
