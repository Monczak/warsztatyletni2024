extends Node2D

@export var jump_velocity = -1000
@onready var trigger_area = $Area2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	trigger_area.body_entered.connect(_on_trigger_area_entered)


func _on_trigger_area_entered(body: Node2D) -> void:
	var local_down = Vector2.DOWN.rotated(rotation)
	if body is Player:
		body.apply_impulse_velocity(local_down * jump_velocity)
	elif body is PlayerInteractable:
		body.fix_position(body.global_position, local_down * jump_velocity, true)
