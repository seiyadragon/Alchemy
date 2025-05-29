extends StaticBody3D
class_name TreeObject

var location_range = 40

func _ready():
	var rand = RandomNumberGenerator.new()
	rand.seed = randi()
	rand.randomize()

	var random_vec = Vector3(rand.randf_range(-location_range, location_range), 0, rand.randf_range(-location_range, location_range))
	self.global_transform.origin = get_parent().get_nearest_build_position(random_vec) + Vector3(0, -1.0, 0)
	self.rotation_degrees.y = rand.randf_range(-360, 360)
