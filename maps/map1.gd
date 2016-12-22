extends Node

var warp_dict = {
	"map_0": {"x": 6, "y": -1, "map": "maps/map0", "face": "se"},
	"end": {"x": 0, "y": 0, "map": "end", "face": "ne"},
}

func _ready():
	 get_node("camera/tile_map/party").set_current_scene(self)

