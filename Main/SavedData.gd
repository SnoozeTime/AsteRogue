extends Node

var saved_data = {
	# Max scores
	"best_time": 60*60, # One hour to finish level?
	"has_finished": false
}

# Set the score for the current level. If high score, will override the saved data
# and returns true.
func set_score(best_time) -> bool:
	if !saved_data["has_finished"]:
		saved_data["has_finished"] = true
		saved_data["best_time"] = best_time
		return true
		
	# If has already finished, get the best score
	saved_data["best_time"] = min(saved_data["best_time"], best_time)
	save_game()
	return saved_data["best_time"] == best_time

# Get current high score
func get_score() -> int:
	return saved_data["best_time"]

func get_has_finished() -> bool:
	return saved_data["has_finished"]

func save_game():
	var file = File.new()
	file.open("user://savegame.save", File.WRITE)
	
	var serialized = to_json(saved_data)
	file.store_line(serialized)
	file.close()
	
func load_game():
	var file = File.new()
	if not file.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	file.open("user://savegame.save", File.READ)
	saved_data = parse_json(file.get_line())
	
	var has_issue = false
	if saved_data is Dictionary:
		if saved_data.has("best_time") and saved_data.has("has_finished"):
			pass
		else:
			has_issue = true
	else:
		has_issue = true
		
	if has_issue:
		print("Issue while loading the data")
		saved_data = {
			# Max scores
			"best_time": 60*60, # One hour to finish level?
			"has_finished": false
		}
	file.close()
