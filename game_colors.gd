extends Node

const NAMES: Array[String] = ["blue", "green", "red", "orange", "yellow", "brown"]

const COLORS: Array[Color] = [
	Color("0000ff"), Color("00c800"), Color("ff0000"),
	Color("ff8800"), Color("ffff00"), Color("663300"),
]

const TILE_SHEET_PATH: String = "res://assets/block tilest.png"
const PLAYER_SIDE_PATH: String = "res://assets/emz_rotate_left and right_%s.png"
const PLAYER_VERT_PATH: String = "res://assets/emz_rotate_up and down_%s.png"

const SIDE_FRAMES: int = 4
const VERT_FRAMES: int = 6

const TILE_COLUMNS: int = 3
const TILE_ROWS: int = 2

const TILE_CELL: Array[int] = [3, 4, 0, 1, 2, 5]

var active_count: int = 6
var _cache: Dictionary = {}

func count() -> int:
	return active_count

func get_color(index: int) -> Color:
	return COLORS[index % COLORS.size()]

func get_color_name(index: int) -> String:
	return NAMES[index % NAMES.size()]

func get_tile_texture(index: int) -> Texture2D:
  var key := "tile_%d" % index
	if _cache.has(key):
		return _cache[key]
	var sheet := _load_tex(TILE_SHEET_PATH)
	if sheet == null:
		return null
	var cell: int = TILE_CELL[index % TILE_CELL.size()]
	var w: float = sheet.get_width() / float(TILE_COLUMNS)
	var h: float = sheet.get_height() / float(TILE_ROWS)
	var atlas := AtlasTexture.new()
	atlas.atlas = sheet
	atlas.region = Rect2((cell % TILE_COLUMNS) * w, (cell / TILE_COLUMNS) * h, w, h)
	_cache[key] = atlas
	return atlas
	
func get_player_side_texture(index: int) -> Texture2D:
	return _load_tex(PLAYER_SIDE_PATH % NAMES[index % NAMES.size()])

func get_player_vert_texture(index: int) -> Texture2D:
	return _load_tex(PLAYER_VERT_PATH % NAMES[index % NAMES.size()])

func random_index(exclude: int = -1) -> int:
	if active_count <= 1:
		return 0
	var i := randi() % active_count
	while i == exclude:
		i = randi() % active_count
	return i

func _load_tex(path: String) -> Texture2D:
	if _cache.has(path):
		return _cache[path]
	var tex: Texture2D = null
	if ResourceLoader.exists(path):
		tex = load(path)
	else:
		push_warning("Missing image: " + path)
	_cache[path] = tex
	return tex
