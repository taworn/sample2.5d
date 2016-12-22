extends Node

var persist = restart_game()

func restart_game():
	var pixel_pos = global.map_to_pixel(Vector2(9, -1))
	var persist = {
		"map": "maps/map0",
		"x": pixel_pos.x,
		"y": pixel_pos.y,
		"face": "sw",
	}
	return persist

