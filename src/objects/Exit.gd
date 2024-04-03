extends Node2D

@onready var trigger_area: Area2D = $Area2D


func _ready() -> void:
	trigger_area.body_entered.connect(_on_trigger_area_entered)


func _on_trigger_area_entered(body: Node2D) -> void:
	if body is Player:
		Game.handle_victory()

