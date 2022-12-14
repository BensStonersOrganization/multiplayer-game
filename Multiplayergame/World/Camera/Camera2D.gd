class_name CameraMain
extends Camera2D

export var move_speed = 0.5  # camera position lerp speed
export var zoom_speed = 0.25  # camera zoom lerp speed
export var min_zoom = 0.5  # camera won't zoom closer than this
export var max_zoom = 2  # camera won't zoom farther than this
export var margin = Vector2(100, 50)  # include some buffer area around targets

export var target_multi_players = true

var targets = []  # Array of targets to be tracked.

onready var screen_size = get_viewport_rect().size


func _ready() -> void:
	set_process(false)


func _physics_process(_delta) -> void:
	if target_multi_players == true:
		if !targets:
			return
		# Keep the camera centered between the targets
		var p = Vector2.ZERO
		for target in targets:
			p += target.position
		p /= targets.size()
		position = lerp(position, p, move_speed)
		# Find the zoom that will contain all targets
		var r = Rect2(position, Vector2.ONE)
		for target in targets:
			r = r.expand(target.position)
		r = r.grow_individual(margin.x, margin.y, margin.x, margin.y)
		var _d = max(r.size.x, r.size.y)
		var z
		if r.size.x > r.size.y * screen_size.aspect():
			z = clamp(r.size.x / screen_size.x, min_zoom, max_zoom)
		else:
			z = clamp(r.size.y / screen_size.y, min_zoom, max_zoom)
		zoom = lerp(zoom, Vector2.ONE * z, zoom_speed)
	elif target_multi_players == false:
		return

func add_target(t) -> void:
	if target_multi_players == true:
		if not t in targets:
			targets.append(t)

func remove_target(t) -> void:
	if target_multi_players == true:
		if t in targets:
			targets.erase(t)


