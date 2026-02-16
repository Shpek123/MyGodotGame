class_name FPSComponent extends Node

@export var pivot: Node3D
@export var head: Node3D

@export var mouse_sensivity := 0.002
@export var smooth_speed := 30.0

var target_horizontal: float = 0.0
var target_vertical: float = 0.0

func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("esc"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			target_horizontal += -event.relative.x * mouse_sensivity
			target_vertical += -event.relative.y * mouse_sensivity
			head.rotation.x = clamp(head.rotation.x, -PI/2, PI/2)
			
func _process(delta: float) -> void:
	pivot.rotation.y = lerp(pivot.rotation.y, target_horizontal, smooth_speed * delta)
	head.rotation.x = lerp(head.rotation.x, target_vertical, smooth_speed * delta)
	
	head.rotation.x = clamp(head.rotation.x, -PI/2, PI/2)
	if head.rotation.x <= -PI/2 or head.rotation.x >= PI/2:
		target_vertical = head.rotation.x
