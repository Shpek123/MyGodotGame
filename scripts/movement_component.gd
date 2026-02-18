class_name MovementComponent extends Node

@export var body: CharacterBody3D
@export var model: Node3D
@export var collision: CollisionShape3D
@export var head: Node3D
@export var walk_speed := 1.5
@export var run_speed := 20.0
@export var crouch_speed := 1.0
@export var jump_velocity := 8.0
@export var gravity_multiplier := 2.5

@onready var original_col_height = collision.shape.height

var current_speed := 0.0
var direction: Vector3 = Vector3.ZERO
var wants_jump := false
var wants_run := false
var wants_crouch := false

func tick(delta: float) -> void:
	if body == null:
		return
		
	# ДВИЖЕНИЕ
	
	# скорость передвижения
	if wants_crouch or body.test_move(body.transform, Vector3(0,1.0,0)):
		current_speed = crouch_speed - (crouch_speed / 2) if Input.is_action_pressed("move_down") else crouch_speed
	elif wants_run:
		current_speed = run_speed - (run_speed / 2) if Input.is_action_pressed("move_down") else run_speed
	else:
		current_speed = walk_speed - (walk_speed / 2) if Input.is_action_pressed("move_down") else walk_speed
		
	# приседание
	if body.test_move(body.transform, Vector3(0,1.0,0)):
			wants_crouch = true
	if wants_crouch:
		head.position.y = lerp(head.position.y, -0.5, 3.0 * delta)
		collision.shape.height = lerp(collision.shape.height, original_col_height - 1.0, 3.0 * delta)
		model.scale.y = lerp(model.scale.y, 0.04, 3.0 * delta)
	else:
		head.position.y = lerp(head.position.y, 0.0, 3.0 * delta)
		collision.shape.height = lerp(collision.shape.height, original_col_height, 3.0 * delta)
		model.scale.y = lerp(model.scale.y, 0.12, 3.0 * delta)
		
	# направление движения
	if body.is_on_floor():
		var target_velocity = -direction * current_speed
		body.velocity.x = lerp(body.velocity.x, target_velocity.x, delta * 7.0)
		body.velocity.z = lerp(body.velocity.z, target_velocity.z, delta * 7.0)
		
	# ГРАВИТАЦИЯ
	if not body.is_on_floor():
		body.velocity += body.get_gravity() * delta * gravity_multiplier
		
	# ПРЫЖОК
	if wants_jump and body.is_on_floor():
		body.velocity.y = jump_velocity
	wants_jump = false
	
