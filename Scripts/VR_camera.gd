extends Camera3D

@export var player_camera: Camera3D
@export var left_eye_control: Control
@export var right_eye_control: Control
@export var divide_value: float = 2
@export var subview_port: SubViewport
@export var subviewport_scale: float = 1

var half_screen_size: Vector2
var left_eye_position: Vector2
var right_eye_position: Vector2
var distance_value: float

func _ready():
	# Set SubViewport size
	subview_port.size = subview_port.size * subviewport_scale
	half_screen_size = DisplayServer.screen_get_size() / 2
	# Set substract value
	distance_value = (half_screen_size.x) / divide_value
	
	left_eye_position.x = (half_screen_size.x) - distance_value
	right_eye_position.x = (half_screen_size.x) + distance_value
	# Set position
	left_eye_control.set_position(Vector2(left_eye_position.x, half_screen_size.y))
	right_eye_control.set_position(Vector2(right_eye_position.x, half_screen_size.y))

func _physics_process(_delta):
	global_rotation = player_camera.global_rotation
	global_position = player_camera.global_position
