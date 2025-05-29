extends StaticBody3D
class_name Plot

var build_grid = 80

var tree_amount = 100
var tree_range = 40
@onready var tree = load("res://objects/tree/tree.tscn")

var build_positions = []
var current_height = 1.01

func _ready():
	for x in build_grid:
		for z in build_grid:
			build_positions.append(Vector3(-40.0, 0, -40.0) + Vector3(x + 0.5, current_height, z + 0.5))
			if x == 0:
				var fence = load("res://objects/fence/fence.tscn").instantiate()
				fence.global_transform.origin = Vector3(-40.0, 0, -40.0) + Vector3(x + 0.5, current_height, z + 0.5)
				fence.rotation_degrees = Vector3(0.0, 270.0, 0.0)
				add_child(fence)
			if z == 0:
				var fence = load("res://objects/fence/fence.tscn").instantiate()
				fence.global_transform.origin = Vector3(-40.0, 0, -40.0) + Vector3(x + 0.5, current_height, z + 0.5)
				fence.rotation_degrees = Vector3(0.0, 180.0, 0.0)
				add_child(fence)
			if x == build_grid - 1:
				var fence = load("res://objects/fence/fence.tscn").instantiate()
				fence.global_transform.origin = Vector3(-40.0, 0, -40.0) + Vector3(x + 0.5, current_height, z + 0.5)
				fence.rotation_degrees = Vector3(0.0, 90.0, 0.0)
				add_child(fence)
			if z == build_grid - 1:
				var fence = load("res://objects/fence/fence.tscn").instantiate()
				fence.global_transform.origin = Vector3(-40.0, 0, -40.0) + Vector3(x + 0.5, current_height, z + 0.5)
				fence.rotation_degrees = Vector3(0.0, 0.0, 0.0)
				add_child(fence)

	
	for i in tree_amount:
		var tree_instance = tree.instantiate()
		tree_instance.location_range = tree_range
		add_child(tree_instance)

func get_nearest_build_position(collision_pos):
	var lowest_distance = Vector3(1, 1, 1)
	var lowest_distance_index = 0
	
	for i in build_grid*build_grid:
		if (build_positions[i] - collision_pos).abs() < lowest_distance.abs():
			lowest_distance = build_positions[i] - collision_pos
			lowest_distance_index = i
			
	return build_positions[lowest_distance_index]
