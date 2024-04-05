extends Node2D

@export var camera: Camera2D
@export var snap_distance: float = 32


func _closest_snap_point(pos: Vector2) -> Vector2:
	return round(pos / snap_distance) * snap_distance 
	
	
func _process(delta: float) -> void:
	global_position = _closest_snap_point(camera.global_position)
