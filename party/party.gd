extends Node2D

var camera = null    # camera to set position (x, y), can be null
var tile_map = null  # tile map
var hero = null      # a hero
var scene = null     # current scene

func _ready():
	camera = get_node("../../../camera")
	tile_map = camera.get_node("tile_map")
	hero = tile_map.get_node("players/hero")

	center_screen()
	set_process_input(true)
	set_process(true)

func _input(event):
	if hero.is_moving():
		return

	var action = 0
	if Input.is_action_pressed("ui_up"):
		action = global.MOVE_NE
	elif Input.is_action_pressed("ui_left"):
		action = global.MOVE_NW
	elif Input.is_action_pressed("ui_right"):
		action = global.MOVE_SE
	elif Input.is_action_pressed("ui_down"):
		action = global.MOVE_SW
	if action != 0:
		hero.move(action)

func on_moving_step():
	center_screen()

func center_screen():
	if camera != null:
		var pos
		pos = hero.get_pos()
		var cam_pos = Vector2(global.half_screen_size.x - pos.x, global.half_screen_size.y - pos.y)
		camera.set_pos(cam_pos)

func after_walk(name):
	if scene.warp_dict.has(name):
		var warp = scene.warp_dict[name]
		var pos = global.map_to_pixel(Vector2(warp.x, warp.y))
		state.persist.x = pos.x
		state.persist.y = pos.y
		state.persist.map = warp.map
		state.persist.face = warp.face
		get_tree().change_scene("res://" + warp.map + ".tscn")

func set_current_scene(scene):
	self.scene = scene

