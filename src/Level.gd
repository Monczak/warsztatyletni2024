extends Node2D
class_name Level

@onready var player_respawn_point_tscn: PackedScene = preload("res://src/special/PlayerRespawnPoint.tscn")
@onready var _player_respawn_point: PlayerRespawnPoint = $PlayerRespawnPoint


func get_player() -> Player:
	return get_node("Player")


func get_player_respawn_point() -> PlayerRespawnPoint:
	return _player_respawn_point


func _ready() -> void:
	if _player_respawn_point == null:
		_player_respawn_point = player_respawn_point_tscn.instantiate()
		add_child(_player_respawn_point)
		_player_respawn_point.global_position = get_player().global_position
