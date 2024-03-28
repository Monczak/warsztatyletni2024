extends RigidBody2D
class_name PlayerInteractable

var _reset_state := false
var _new_position: Vector2
var _vel: Vector2


func fix_position(new_pos: Vector2, vel: Vector2) -> void:
    _reset_state = true
    _new_position = new_pos
    _vel = vel


func unfix_position() -> void:
    _reset_state = false


func _ready() -> void:
    set_can_sleep(false)


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
    if _reset_state:
        state.transform.origin = _new_position
        state.linear_velocity = _vel
        state.angular_velocity = 0
