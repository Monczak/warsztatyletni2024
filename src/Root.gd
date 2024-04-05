extends Node2D
class_name Root

@export var world_tscn: PackedScene


func load_world() -> void:
	if has_node("World"):
		remove_child(get_node("World"))
	
	var world = world_tscn.instantiate()
	add_child(world)
