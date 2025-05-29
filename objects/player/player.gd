extends CharacterBody3D

var mouse_delta: Vector2 = Vector2.ZERO

@export var gravity: float = 25.0
@export var speed: float = 6.0
@export var look_sensitivity: float = 20.0
@export var select_distance: float = 6.0

@onready var buildings: Array[PackedScene] = [
	preload("res://objects/floor/floor.tscn"),
	preload("res://objects/storage/storage.tscn"),
	preload("res://objects/wall/wall.tscn"),
	preload("res://objects/fence/fence.tscn"),
	preload("res://objects/well/well.tscn")
]

var build: bool = false
var build_item: int = 1
var build_rotation: float = 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$build_mesh.visible = false

	var rand := RandomNumberGenerator.new()
	rand.randomize()

	global_position.y = 5
	global_position.x = rand.randf_range(-20, 20)
	global_position.z = rand.randf_range(-20, 20)

	$camera/raycast.target_position = Vector3.FORWARD * select_distance

func _physics_process(delta: float) -> void:
	var input: Vector2 = Vector2.ZERO

	if Input.is_action_pressed("move_forward"):
		input.y += 1
	if Input.is_action_pressed("move_backwards"):
		input.y -= 1
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	if Input.is_action_pressed("move_right"):
		input.x += 1

	input = input.normalized()

	var forward: Vector3 = -transform.basis.z
	var right: Vector3 = transform.basis.x
	var direction: Vector3 = (forward * input.y + right * input.x).normalized()

	velocity.y -= gravity * delta
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	move_and_slide()

	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = speed

	if Input.is_action_just_pressed("build"):
		build = not build

	if Input.is_action_just_pressed("rotate"):
		build_rotation = fmod(build_rotation + 90.0, 360.0)

	$camera/crosshair/label.text = ""
	$build_mesh.visible = false
	$build_mesh.rotation_degrees = Vector3(0.0, build_rotation, 0.0) - rotation_degrees

	if build:
		$camera/crosshair/label.text = "Build Mode: LC to remove RC to build"
		var raycast := $camera/raycast

		if raycast.is_colliding():
			var collider: Object = raycast.get_collider()
			var collision_point: Vector3 = raycast.get_collision_point()

			if collider is Plot:
				var plot := collider as Plot
				var pos: Vector3 = plot.get_nearest_build_position(collision_point)

				var mesh_instance: Node3D = buildings[build_item].instantiate()
				$build_mesh.mesh = mesh_instance.get_child(0).mesh
				$build_mesh.global_position = pos
				$build_mesh.visible = true

				if Input.is_action_just_pressed("interact2"):
					var floor_obj: Node3D = buildings[build_item].instantiate()
					floor_obj.global_position = pos
					floor_obj.rotation_degrees = Vector3(0.0, build_rotation, 0.0)
					plot.add_child(floor_obj)

			elif collider is BuildingItem:
				var floor_collider := collider as BuildingItem
				var pos: Vector3 = floor_collider.build_position

				var mesh_instance: Node3D = buildings[build_item].instantiate()
				$build_mesh.mesh = mesh_instance.get_child(0).mesh
				$build_mesh.global_position = pos

				if floor_collider.should_build:
					$build_mesh.visible = true

				if Input.is_action_just_pressed("interact1"):
					floor_collider.queue_free()

				if Input.is_action_just_pressed("interact2") and floor_collider.should_build:
					var floor_obj: Node3D = buildings[build_item].instantiate()
					floor_obj.global_position = pos
					floor_obj.rotation_degrees = Vector3(0.0, build_rotation, 0.0)
					get_parent().add_child(floor_obj)

			elif collider is TreeObject:
				if Input.is_action_just_pressed("interact1"):
					collider.queue_free()

func _process(delta: float) -> void:
	$camera.rotation_degrees.x -= mouse_delta.y * look_sensitivity * delta
	$camera.rotation_degrees.x = clamp($camera.rotation_degrees.x, -70.0, 70.0)
	rotation_degrees.y -= mouse_delta.x * look_sensitivity * delta
	mouse_delta = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_delta = event.relative
