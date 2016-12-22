extends Node2D

const STEP_TIME = 100

var moving = false   # is moving?
var animate = null   # animation to act various tasks
var tile_map = null  # tile map

var distance = null
var next_pos = null
var time_used = 0

var party = null

func _ready():
	set_pos(global.normalize(Vector2(state.persist.x, state.persist.y)))
	moving = false
	animate = get_node("animate")
	animate.set_animation(state.persist.face)
	tile_map = get_node("../../../tile_map")
	party = tile_map.get_node("party")
	set_process(true)

func _process(delta):
	if moving:
		moving_step(delta)

func is_moving():
	return moving

func get_current_pos():
	if !moving:
		return get_pos()
	else:
		return next_pos

func get_face():
	return animate.get_animation()

func set_face(action):
	if typeof(action) == TYPE_INT:
		distance = null
		if action == global.MOVE_NE:
			distance = Vector2(global.HALF_STEP_X, -global.HALF_STEP_Y)
			animate.set_animation("ne")
		elif action == global.MOVE_NW:
			distance = Vector2(-global.HALF_STEP_X, -global.HALF_STEP_Y)
			animate.set_animation("nw")
		elif action == global.MOVE_SE:
			distance = Vector2(global.HALF_STEP_X, global.HALF_STEP_Y)
			animate.set_animation("se")
		elif action == global.MOVE_SW:
			distance = Vector2(-global.HALF_STEP_X, global.HALF_STEP_Y)
			animate.set_animation("sw")
	else:
		animate.set_animation(action)
	state.persist.face = animate.get_animation()

func move(action):
	set_face(action)
	if distance != null:
		var pos = get_pos()
		next_pos = Vector2(pos.x + distance.x, pos.y + distance.y)
		if check_before_walk():
			animate.set_frame(0)
			time_used = 0
			moving = true
			return true
	return false

func moving_step(delta):
	var finish_x = false
	var finish_y = false
	var d = ceil(delta * 1000)
	var dx = ceil(d * distance.x / STEP_TIME)
	var dy = ceil(d * distance.y / STEP_TIME)
	var pos = get_pos()
	pos.x += dx
	pos.y += dy

	if distance.x < 0:
		if pos.x <= next_pos.x:
			pos.x = next_pos.x
			finish_x = true
	elif distance.x > 0:
		if pos.x >= next_pos.x:
			pos.x = next_pos.x
			finish_x = true

	if distance.y < 0:
		if pos.y <= next_pos.y:
			pos.y = next_pos.y
			finish_y = true
	elif distance.y > 0:
		if pos.y >= next_pos.y:
			pos.y = next_pos.y
			finish_y = true

	set_pos(pos)
	party.on_moving_step()
	if finish_x && finish_y:
		animate.set_frame(0)
		moving = false
		state.persist.x = pos.x
		state.persist.y = pos.y
		check_after_walk()

func check_before_walk():
	# checks map
	var map_pos = global.pixel_to_map(next_pos)
	var id = tile_map.get_cell(map_pos.x, map_pos.y)
	var name = tile_map.get_tileset().tile_get_name(id)
	if global.passable_walk_dict.has(name) && global.passable_walk_dict[name]:
		return true
	return false

func check_after_walk():
	var pos = get_pos()

	# checks scripts
	var scripts = tile_map.get_node("scripts")
	var count = scripts.get_child_count()
	var i = 0
	while i < count:
		var child = scripts.get_child(i)
		if !child.is_hidden():
			var rect = Rect2(child.get_pos(), child.get_size())
			if rect.has_point(pos):
				party.after_walk(child.get_name())
				return true
		i += 1

	party.after_walk(null)
	return false

