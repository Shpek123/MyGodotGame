class_name FlashlightComponent extends Node

@export var flashlight_pivot: Node3D
@export var flashlight_light: SpotLight3D
@export var head: Node3D
@export var pivot: Node3D

@export var mouse_sensitivity := 0.002
@export var camera_follow_speed := 5.0
@export var max_vertical_angle := 70.0

@export var max_battery := 100.0
@export var current_battery := 100.0
@export var drain_rate := 6.67  # 100% / 15 секунд
@export var recharge_rate := 3.33

var intensity := 0.0
var target_intensity := 0.0
var is_on: bool = false

# Целевые повороты для фонарика (куда целится мышь)
var target_flashlight_rot: Vector2 = Vector2.ZERO

func _ready():
	# Инициализируем целевые повороты текущими значениями
	target_flashlight_rot.x = flashlight_pivot.rotation.y
	target_flashlight_rot.y = flashlight_pivot.rotation.x
	update_light()

func _input(event: InputEvent):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Фонарик поворачивается от мыши
		target_flashlight_rot.x += -event.relative.x * mouse_sensitivity
		target_flashlight_rot.y += -event.relative.y * mouse_sensitivity
		
		# Ограничиваем вертикальный угол
		target_flashlight_rot.y = clamp(target_flashlight_rot.y, deg_to_rad(-max_vertical_angle), deg_to_rad(max_vertical_angle))
		
		# Фонарик поворачивается
		flashlight_pivot.rotation.x = target_flashlight_rot.y
		flashlight_pivot.rotation.y = target_flashlight_rot.x
	
	# Колесико мыши
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_intensity = clamp(intensity + 0.1, 0.0, 1.0)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_intensity = clamp(intensity - 0.1, 0.0, 1.0)


func _process(delta: float):
	if intensity != target_intensity:
		intensity = move_toward(intensity, target_intensity, delta * 2.0)
		update_light()
	
	# ГОЛОВА ПЛАВНО СЛЕДУЕТ ЗА ФОНАРИКОМ
	head.rotation.y = lerp(head.rotation.y, target_flashlight_rot.x, camera_follow_speed * delta)
	head.rotation.x = lerp(head.rotation.x, target_flashlight_rot.y, camera_follow_speed * delta)
	
	is_on = intensity > 0
	update_battery(delta)

func update_light():
	flashlight_light.visible = is_on
	
	if is_on:
		# Яркость
		flashlight_light.light_energy = intensity
		# Дальность
		flashlight_light.spot_range = 5 + (intensity * 15)  # от 5 до 20
		# УГОЛ
		flashlight_light.spot_angle = 20 + (intensity * 20)  # от 10 до 40 градусов
		# Резкость края
		flashlight_light.spot_angle_attenuation = 5.0
	else:
		flashlight_light.light_energy = 0

func update_battery(delta):
	if is_on:
		current_battery -= drain_rate * intensity * delta
		if current_battery <= 0:
			current_battery = 0
			intensity = 0
			target_intensity = 0
			update_light()
	else:
		current_battery += recharge_rate * delta
		current_battery = min(current_battery, max_battery)
	
	# Мигание при низком заряде (ниже 20%)
	if is_on and current_battery < 20.0:
		flashlight_light.light_energy = intensity * (0.7 + 0.3 * sin(Time.get_ticks_msec() * 0.02))
	
	
