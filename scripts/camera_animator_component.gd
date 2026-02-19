class_name CameraAnimatorComponent extends Node

@export var animation_player: AnimationPlayer
@export var movement: MovementComponent

enum state { IDLE, WALK, CROUCH }

var current_state: state = state.IDLE
var was_crouching: bool = false
