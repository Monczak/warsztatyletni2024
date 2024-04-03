extends RigidBody2D
class_name Player

@export var max_speed := 600.0
@export var jump_impulse := -600.0
@export var acceleration := 3000.0

@export var jump_gravity_multiplier := 0.6
@export var fall_gravity_multiplier := 2.2

@export var animation_speed_idle := 5.0
@export var animation_speed_full_speed := 5.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var grab_point: Node2D = $GrabPoint
@onready var interaction_area: Area2D = $InteractionArea
@onready var jump_area: Area2D = $JumpArea

var _player_interactables := []
var _grabbed_interactable = null

var _impulse_velocity: Vector2
var _apply_impulse_velocity := false

var _controls_enabled := true

var _current_frame = 0
var _last_frame_change_time = 0
var _frame_count

var _facing_right = true


func _calculate_gravity() -> Vector2:
	var gravity := get_gravity()
	var is_jumping = Input.is_action_pressed("Jump")

	if is_jumping and linear_velocity.y < -0.01:
		gravity *= jump_gravity_multiplier
	elif linear_velocity.y < -0.01:
		gravity *= fall_gravity_multiplier
	
	return gravity


func _on_body_entered_interaction_area(body: Node2D) -> void:
	if body is PlayerInteractable:
		_player_interactables.append(body)


func _on_body_exited_interaction_area(body: Node2D) -> void:
	if body is PlayerInteractable:
		_player_interactables.erase(body)


func _interact() -> void:
	if _grabbed_interactable != null:
		if(_grabbed_interactable is RigidBody2D):
			mass -= _grabbed_interactable.mass
		_grabbed_interactable.unfix_position()
		_grabbed_interactable.off_interaction()
		_grabbed_interactable = null
	else:
		if len(_player_interactables) == 0:
			return

		var nearest_interactable = _player_interactables[0]
		for interactable in _player_interactables:
			var distance: float = (interactable.position - position).length()
			if distance < (nearest_interactable.position - position).length():
				nearest_interactable = interactable
		
		_grabbed_interactable = nearest_interactable
		if(_grabbed_interactable is RigidBody2D):
			mass += _grabbed_interactable.mass
		_grabbed_interactable.on_interaction()
	

func _ready() -> void:
	interaction_area.body_entered.connect(_on_body_entered_interaction_area)
	interaction_area.body_exited.connect(_on_body_exited_interaction_area)
	
	_frame_count = sprite.hframes * sprite.vframes
	
	Game.victory.connect(func(): _controls_enabled = false)
	Game.start.connect(func(): _controls_enabled = true)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact"):
		_interact()

	if _grabbed_interactable != null:
		_grabbed_interactable.fix_position(grab_point.global_position, linear_velocity)

	_animate_sprite()


func _animate_sprite() -> void:
	var time = Time.get_ticks_msec() / 1000.0
	var vel_ratio = inverse_lerp(0, max_speed, abs(linear_velocity.x))
	var anim_speed = lerp(animation_speed_idle, animation_speed_full_speed, vel_ratio)
   
	if linear_velocity.x < -0.01:
		_facing_right = false
	elif linear_velocity.x > 0.01:
		_facing_right = true

	if time - _last_frame_change_time > 1.0 / anim_speed:
		_current_frame += -1 if _facing_right else 1
		_current_frame = (_current_frame + _frame_count) % _frame_count
		sprite.frame = _current_frame
		_last_frame_change_time = time
	
	

func _physics_process(delta: float) -> void:
	var impulse = linear_velocity * mass
	if not is_on_floor():
		impulse += _calculate_gravity() * delta * mass
		
	if _apply_impulse_velocity:
		impulse = _impulse_velocity * mass
		_apply_impulse_velocity = false

	if Input.is_action_just_pressed("Jump") and _controls_enabled and is_on_floor():
		impulse.y = jump_impulse

	var direction := Input.get_axis("MoveLeft", "MoveRight")
	if direction and _controls_enabled:
		impulse.x = move_toward(impulse.x, direction * max_speed * mass, acceleration * delta * mass)
	else:
		impulse.x = move_toward(impulse.x, 0, acceleration * delta * mass)
	apply_central_impulse(impulse - linear_velocity * mass)
	#move_and_slide()
	
func is_on_floor() -> bool:
	#print_debug(jump_area.get_overlapping_bodies().size())
	if(jump_area.get_overlapping_bodies().size()>1):
		return true
	return false


func apply_impulse_velocity(vel: Vector2) -> void:
	_apply_impulse_velocity = true
	_impulse_velocity = vel
	

func _on_death() -> void:
	print("I am dead")
	Game.handle_player_death()
