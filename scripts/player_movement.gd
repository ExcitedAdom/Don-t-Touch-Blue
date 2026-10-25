extends CharacterBody2D


@export var speed: float = 250.0
@export var anim_fps: float = 10.0

@export var right_anim: Vector2i = Vector2i(0, 4)
@export var left_anim: Vector2i = Vector2i(0, 4)
@export var down_anim: Vector2i = Vector2i(0, 6)
@export var up_anim: Vector2i = Vector2i(0, 6)

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var _color: int = 0
var _facing: String = "right"
var _anim_time: float = 0.0

func _ready() -> void:
	_color = GameState.current_color
	Events.color_changed.connect(_on_color_changed)
	_update_sprite()

func _physics_process(delta: float) -> void:

	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity.x = dir * speed
	move_and_slide()
	_animate(dir, delta)

func _animate(dir: Vector2, delta: float) -> void:
	if dir == Vector2.ZERO:
		return

	var new_facing := ""
	if absf(dir.y) > absf(dir.x):
		new_facing = "down" if dir.y > 0.0 else "up"
	else:
		new_facing = "right" if dir.x > 0.0 else "left"

	if new_facing != _facing:
		_facing = new_facing
		_anim_time = 0.0
		_update_sprite()

	var anim := _get_anim()
	_anim_time += delta * anim_fps
	sprite.frame = anim.x + (int(_anim_time) % maxi(anim.y, 1))

func _get_anim() -> Vector2i:
	match _facing:
		"left": return left_anim
		"up": return up_anim
		"down": return down_anim
	return right_anim

func _update_sprite() -> void:
	if _facing == "up" or _facing == "down":
		
