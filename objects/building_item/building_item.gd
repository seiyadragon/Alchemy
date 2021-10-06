extends StaticBody
class_name BuildingItem

var build_position = Vector3.ZERO
export var height = 0.1
export var should_build = true

func _ready():
	build_position = global_transform.origin + Vector3(0, height, 0)