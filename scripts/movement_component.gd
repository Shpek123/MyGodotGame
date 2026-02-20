class_name MovementComponent extends Node

@export var body: CharacterBody3D
@export var collision: CollisionShape3D
@export var head: Node3D
@export var walk_speed := 2.0
@export var run_speed := 4.0
@export var crouch_speed := 1.5
@export var jump_velocity := 5.0
@export var gravity_multiplier := 1.5

# Параметры выносливости
@export var max_stamina := 100.0
@export var current_stamina := 100.0
@export var stamina_drain_rate := 10.0  # в секунду
@export var stamina_regen_rate := 10.0  # в секунду

@onready var original_col_height = collision.shape.height
@onready var original_head_y = head.position.y

var current_speed := 0.0
var direction: Vector3 = Vector3.ZERO
var wants_jump := false
var wants_run := false
var wants_crouch := false
var is_crouching := false

func tick(delta: float) -> void:
	if body == null:
		return
	
	# Обновление выносливости
	update_stamina(delta)
	
	# Скорость
	if is_crouching:
		current_speed = crouch_speed - (crouch_speed / 2) if Input.is_action_pressed("move_down") else crouch_speed
	elif wants_run and current_stamina > 0:
		current_speed = run_speed - (run_speed / 2) if Input.is_action_pressed("move_down") else run_speed
	else:
		current_speed = walk_speed - (walk_speed / 2) if Input.is_action_pressed("move_down") else walk_speed
	
	# Приседание
	if wants_crouch:
		is_crouching = true
		head.position.y = lerp(head.position.y, original_head_y - 0.5, delta * 3.0)
		collision.shape.height = lerp(collision.shape.height, original_col_height - 0.8, delta * 3.0)
	else:
		if not body.test_move(body.transform, Vector3(0, 1, 0)):
			is_crouching = false
			head.position.y = lerp(head.position.y, original_head_y, delta * 3.0)
			collision.shape.height = lerp(collision.shape.height, original_col_height, delta * 3.0)
	
	# Движение
	if body.is_on_floor():
		var target_velocity = -direction * current_speed
		body.velocity.x = lerp(body.velocity.x, target_velocity.x, delta * 7.0)
		body.velocity.z = lerp(body.velocity.z, target_velocity.z, delta * 7.0)
	
	# Гравитация
	if not body.is_on_floor():
		body.velocity += body.get_gravity() * delta * gravity_multiplier
	
	# Прыжок
	if wants_jump and body.is_on_floor():
		body.velocity.y = jump_velocity

func update_stamina(delta: float):
	if wants_run and body.is_on_floor() and direction.length() > 0 and current_stamina > 0:
		current_stamina -= stamina_drain_rate * delta
		current_stamina = max(current_stamina, 0)
	else:
		if current_stamina < max_stamina:
			current_stamina += stamina_regen_rate * delta
			current_stamina = min(current_stamina, max_stamina)
