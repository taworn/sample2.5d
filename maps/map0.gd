extends Node

var warp_dict = {
	"map_1": {"x": 15, "y": 5, "map": "maps/map1", "face": "sw"},
}

func _ready():
	 get_node("camera/tile_map/party").set_current_scene(self)

