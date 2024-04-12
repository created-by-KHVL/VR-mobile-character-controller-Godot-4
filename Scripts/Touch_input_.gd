extends Node

var touch_points: Dictionary = {}

var is_left_finger: bool = false
var is_right_finger: bool = false

var first_left_finger_index: int = -1
var first_right_finger_index: int = -1

var half_screen_size: Vector2
var left_finger_start_position: Vector2
var right_finger_start_position: Vector2
var left_finger_current_position: Vector2
var right_finger_current_position: Vector2
var left_finger_direction: Vector2
var right_finger_direction: Vector2

func _ready():
	half_screen_size = Vector2(DisplayServer.screen_get_size().x / 2, 0)

func _process(delta):
	if is_left_finger:
		left_finger_action()
	else:
		left_finger_direction = Vector2.ZERO
	
	if is_right_finger:
		right_finger_action()
	else:
		right_finger_direction = Vector2.ZERO

func _input(event):
	if event is InputEventScreenTouch:
		handle_touch(event)
	elif event is InputEventScreenDrag:
		handle_drag(event)

func handle_touch(event: InputEventScreenTouch):
	if event.pressed:
		if event.index not in touch_points:
			touch_points[event.index] = event.position
		
			if event.position.x < half_screen_size.x and not is_left_finger:
				is_left_finger = true
				left_finger_start_position = event.position
				first_left_finger_index = event.index
			elif event.position.x >= half_screen_size.x and not is_right_finger:
				is_right_finger = true
				right_finger_start_position = event.position
				first_right_finger_index = event.index
	else:
		if event.index == first_left_finger_index:
			is_left_finger = false
			left_finger_start_position = Vector2.ZERO
			first_left_finger_index = -1
		elif event.index == first_right_finger_index:
			is_right_finger = false
			right_finger_start_position = Vector2.ZERO
			first_right_finger_index = -1
		touch_points.erase(event.index)

func handle_drag(event: InputEventScreenDrag):
	if event.index == first_left_finger_index:
		left_finger_current_position = event.position
	elif event.index == first_right_finger_index:
		right_finger_current_position = event.position

func left_finger_action():
	left_finger_direction = left_finger_start_position.direction_to(left_finger_current_position)

func right_finger_action():
	right_finger_direction = right_finger_start_position.direction_to(right_finger_current_position)
