class_name CameraAnimatorComponent extends Node

@export var animation_player: AnimationPlayer
@export var movement_component: MovementComponent

func _ready():
	if movement_component.direction.length() > 0.1:
		animation_player.play("WALK")
	else:
		animation_player.play("IDLE")
