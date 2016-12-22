extends Node

# move in direction
const MOVE_NE = 1
const MOVE_NW = 2
const MOVE_SE = 3
const MOVE_SW = 4

# one step size, in pixels
const STEP_X = 64
const STEP_Y = 32
const HALF_STEP_X = 32
const HALF_STEP_Y = 16

# screen size, in pixel
var screen_size = {
	"x": Globals.get("display/width"),
	"y": Globals.get("display/height"),
}
var half_screen_size = {
	"x": screen_size.x >> 1,
	"y": screen_size.y >> 1,
}

# passable walking map
var passable_walk_dict = {
	"floor_0": 1, "floor_1": 1,
	"door_0": 1, "door_1": 1,
}

# converts pixel position to map position
func pixel_to_map(pixel_pos):
	pixel_pos.y -= 24
	var map_pos = Vector2((pixel_pos.x / HALF_STEP_X + pixel_pos.y / HALF_STEP_Y) / 2, (pixel_pos.y / HALF_STEP_Y - pixel_pos.x / HALF_STEP_X) / 2)
	return map_pos

# converts map position to pixel position
func map_to_pixel(map_pos):
	var pixel_pos = Vector2((map_pos.x - map_pos.y) * HALF_STEP_X, (map_pos.x + map_pos.y) * HALF_STEP_Y)
	pixel_pos.y += 24
	return pixel_pos

# converts position to aligh in (STEP_X, STEP_Y)
func normalize(pixel_pos):
	return map_to_pixel(pixel_to_map(pixel_pos))

