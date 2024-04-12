extends CharacterBody3D

@export var camera: Camera3D
@export var speed: float = 4

const JUMP_VELOCITY = 4.5

var start_speed: float
var start_camera_fov: int

var is_jumping: bool = false
var is_running: bool = false

var input_direction: Vector2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	start_speed = speed
	start_camera_fov = camera.fov

func _process(delta):
	if Input.is_action_pressed("run") and abs(input_direction) > Vector2.ZERO:
		is_running = true
	else:
		is_running = false
	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		is_jumping = true
		velocity.y = JUMP_VELOCITY
	# Move player
	if is_on_floor():
		is_jumping = false
		player_movement()
	# Player rotation
	if not is_jumping and not is_running:
		player_rotation()
	
	move_and_slide()
	player_rotation()

func player_movement():
	var fov_change_speed: int = 2
	if is_running:
		var acceleration: int = 4
		speed = start_speed + acceleration
		camera.fov = move_toward(camera.fov, start_camera_fov + 15, fov_change_speed)
	else:
		speed = start_speed
		camera.fov = move_toward(camera.fov, start_camera_fov, fov_change_speed)
	
	input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
func player_rotation():
	var sensitivity: float
	# Gamepad input
	var controller_view_rotation = Input.get_vector("look_up", "look_down", "look_left", "look_right")
	sensitivity = 2
	camera.rotation_degrees.x -= controller_view_rotation.x * sensitivity 
	rotation_degrees.y -= controller_view_rotation.y * sensitivity
	# Gyroscope input
	var gyroscope = Input.get_gyroscope() * .2
	camera.rotate_x(gyroscope.x * .2)
	rotate_y(gyroscope.y * .2)
	# Clamp camera
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
