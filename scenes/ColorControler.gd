extends Node

const warning_time := 1.5
const min_interval := 2.0
const speed_up := 0.25

var interval := 5.0
var timer := 0.0
var warning := false

func _process(delta: float) -> void:
	if not GameState.running:
		return
	timer += delta
	
	if not warning and timer >= interval:
		warning = true
		timer = 0.0
		GameState.next_color = GameColors.random_index(GameState.current_color)
		Events.color_warning.emit(GameState.next_color)
		
	elif warning and timer >= interval:
		warning = false
		timer = 0.0
		GameState.current_color = GameState.next_color
		Events.color_changed.emit(GameState.current_color)
		interval = max(min_interval, interval - speed_up)
