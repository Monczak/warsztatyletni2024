extends Node


signal victory
signal reset
signal start


@onready var _root: Root = get_tree().root.get_node("Root")


func get_world() -> World:
	return _root.get_node("World")


func get_camera() -> Camera:
	return get_world().get_camera()


func get_level() -> Level:
	return get_world().get_level()
	

func get_particles() -> Particles:
	return get_world().get_particles()


func get_player() -> Player:
	return get_level().get_player()


func get_player_respawn_point() -> Node2D:
	return get_level().get_player_respawn_point()


func handle_player_death() -> void:
	get_camera().target = null
	
	get_particles().emit_particles("player_death", get_player().global_position)

	await get_tree().create_timer(0.6).timeout
	var player = get_world().spawn_player()
	get_camera().target = player


func handle_victory() -> void:
	victory.emit()
	print("Level complete!")


func reset_game() -> void:
	reset.emit()
	_root.load_world()
	start.emit()
	
	await get_tree().process_frame
	
	get_camera().target = get_level().get_node("Player")
	
	
func _ready() -> void:
	reset_game()

