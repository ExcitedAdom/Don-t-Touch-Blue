extends Node2D

const Cols := 14
const Rows := 8
const Tile := 80
const Shuffle_Interval := 10.0
var shuffle_timer := 0.0

var grid: Array = []



func _ready() -> void:
	randomize()
	generate()
	Events.color_changed.connect(_on_color_changed)
	GameState.reset()

func generate() -> void:
	grid.clear()
	for y in Rows:
		var row := []
		for x in Cols:
			row.append(randi() % GameColors.count())
		grid.append(row)
	queue_redraw()
	
func get_size() -> Vector2:
	return Vector2(Cols, Rows) * Tile
	
func get_tile_color_at(world_pos: Vector2) -> int:
	var local := to_local(world_pos)
	var x := int(floor(local.x / Tile))
	var y := int(floor(local.y/ Tile))
	if x < 0 or y < 0 or x >= Cols or y >= Rows:
		return -1
	return grid[y][x]
	
func _on_color_changed(_c: int) -> void:
	queue_redraw()
	
func _process(delta: float) -> void:
	if GameState.running:
		shuffle_timer += delta
		if shuffle_timer >= Shuffle_Interval:
			shuffle_timer = 0.0
			shuffle_grid()
	queue_redraw()
	
func _draw() -> void:
	var pulse := 3.0 + sin(Time.get_ticks_msec() / 150.0) * 2.0
	for y in Rows:
		for x in Cols:
			var id: int = grid[y][x]
			var rect := Rect2(x * Tile, y * Tile, Tile, Tile)
			var tex := GameColors.get_tile_texture(id)
			if tex != null:
				draw_texture_rect(tex, rect, false)
			else:
				draw_rect(rect.grow(-2), GameColors.get_color(id))
			if GameState.running and id == GameState.current_color:
				draw_rect(rect.grow(-6), Color.WHITE, false, pulse)
	
func shuffle_grid() -> void:
	var flat:Array = []
	for row in grid:
		flat.append_array(row)
	flat.shuffle()

	var i := 0
	for y in Rows:
		for x in Cols:
			grid[y][x] = flat[i]
			i += 1
	queue_redraw()
