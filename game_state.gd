extends Node

var current_color := 0
var next_color := 0
var time_survived := 0.0
var running := false

func reset() -> void:
	current_color  = randi() % GameColors.COUNT
	next_color = current_color
	time_survived = 0.0
	running = true
