class_name InputComponent extends Node

var move_dir: Vector2 = Vector2.ZERO
var jump_pressed := false
var shift_pressed := false
var crouch_pressed := false

func update() -> void:
	move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	jump_pressed = Input.is_action_just_pressed("jump")
	shift_pressed = Input.is_action_pressed("run")
	crouch_pressed = Input.is_action_pressed("crouch")
