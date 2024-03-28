extends Node2D
class_name World

@export var player_tscn: PackedScene

@onready var _level: Level = $Level
@onready var _camera: Camera = $Camera2D


func get_level() -> Level:
    return _level


func get_camera() -> Camera:
    return _camera

    
func spawn_player() -> Player:
    var player := player_tscn.instantiate() as Player
    player.global_position = get_level().get_player_respawn_point().global_position
    add_child(player)
    return player
