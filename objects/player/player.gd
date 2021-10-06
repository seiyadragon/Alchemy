extends KinematicBody

var velocity = Vector3.ZERO
var mouse_delta = Vector2.ZERO

var gravity = 25
var speed = 6
var look_sensitivity = 20
var select_distance = 6

onready var buildings = [load("res://objects/floor/floor.tscn"), load("res://objects/storage/storage.tscn"), load("res://objects/wall/wall.tscn"), load("res://objects/fence/fence.tscn"), load("res://objects/well/well.tscn")]

var build = false
var build_item = 4
var build_rotation = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$build_mesh.visible = false
	
	var rand = RandomNumberGenerator.new()
	rand.seed = randi()
	rand.randomize()
	
	self.global_transform.origin.y = 5
	self.global_transform.origin.x = rand.randf_range(-20, 20)
	self.global_transform.origin.z = rand.randf_range(-20, 20)
	
	$camera/raycast.set_cast_to(Vector3.FORWARD * 
	Vector3(select_distance, select_distance, select_distance))

func _physics_process(delta):
	velocity.x = 0
	velocity.z = 0
	
	var input = Vector2.ZERO
	
	if Input.is_action_pressed("move_forward"):
		input.y -= 1
	if Input.is_action_pressed("move_backwards"):
		input.y += 1
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	if Input.is_action_pressed("move_right"):
		input.x += 1
		
	input = input.normalized()
	
	var forward = global_transform.basis.z
	var right = global_transform.basis.x
	
	var relative_dir = (forward * input.y + right * input.x)
	
	velocity.x = relative_dir.x * speed
	velocity.y -= gravity * delta
	velocity.z = relative_dir.z * speed
	
	velocity = move_and_slide(velocity, Vector3.UP)
	
	if Input.is_action_pressed("move_jump") and is_on_floor():
		velocity.y = speed

	if (Input.is_action_just_pressed("build")):
		build = not build

	if Input.is_action_just_pressed("rotate"):
		build_rotation += 90.0
		if build_rotation >= 360.0:
			build_rotation = 0.0
	
	$camera/crosshair/label.text = ""
	$build_mesh.visible = false
	$build_mesh.rotation_degrees = Vector3(0.0, build_rotation, 0.0) - rotation_degrees
	
	if build:
		$camera/crosshair/label.text = "Build Mode: LC to remove RC to build"

		if $camera/raycast.is_colliding():
			if $camera/raycast.get_collider() is Plot:
				var plot = $camera/raycast.get_collider()
				var pos = plot.get_nearest_build_position($camera/raycast.get_collision_point())
				$build_mesh.mesh = buildings[build_item].instance().get_child(0).mesh
				$build_mesh.global_transform.origin = pos
				$build_mesh.visible = true

				if Input.is_action_just_pressed("interact2"):
					var floor_obj = buildings[build_item].instance()
					floor_obj.global_transform.origin = pos
					floor_obj.rotation_degrees = Vector3(0.0, build_rotation, 0.0)
					plot.add_child(floor_obj)

			elif $camera/raycast.get_collider() is BuildingItem:
				var floor_collider = $camera/raycast.get_collider()
				var pos = floor_collider.build_position
				$build_mesh.mesh = buildings[build_item].instance().get_child(0).mesh
				$build_mesh.global_transform.origin = pos
				if floor_collider.should_build:
					$build_mesh.visible = true
				
				if Input.is_action_just_pressed("interact1"):
					$camera/raycast.get_collider().queue_free()
					
				if Input.is_action_just_pressed("interact2"):
					if floor_collider.should_build:
						var floor_obj = buildings[build_item].instance()
						floor_obj.global_transform.origin = pos
						floor_obj.rotation_degrees = Vector3(0.0, build_rotation, 0.0)
						get_parent().add_child(floor_obj)

			elif $camera/raycast.get_collider() is TreeObject:
				if Input.is_action_just_pressed("interact1"):
					$camera/raycast.get_collider().queue_free()
				
func _process(delta):
	$camera.rotation_degrees.x -= mouse_delta.y * look_sensitivity * delta
	$camera.rotation_degrees.x = clamp($camera.rotation_degrees.x, -70, 70)
	
	rotation_degrees.y -= mouse_delta.x * look_sensitivity * delta
	
	mouse_delta = Vector2.ZERO 
		
func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative
