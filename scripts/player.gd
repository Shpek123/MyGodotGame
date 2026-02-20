class_name Player extends CharacterBody3D

@onready var input_component: InputComponent = $InputComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var camera_animator_component: CameraAnimatorComponent = $CameraAnimatorComponent
@onready var flashlight_component: FlashlightComponent = $FlashlightComponent

func _physics_process(delta: float) -> void:
	# РЕГИСТРАЦИЯ ВВОДА
	input_component.update()
	
	# ДВИЖЕНИЕ
	movement_component.wants_crouch = input_component.crouch_pressed
	movement_component.wants_run = input_component.shift_pressed
	
	# Направление относительно фонарика
	var move_dir_input = Vector3(input_component.move_dir.x, 0, input_component.move_dir.y)
	movement_component.direction = (flashlight_component.flashlight_pivot.transform.basis * move_dir_input).normalized()
	
	movement_component.wants_jump = input_component.jump_pressed
	movement_component.tick(delta)
	
	move_and_slide()
