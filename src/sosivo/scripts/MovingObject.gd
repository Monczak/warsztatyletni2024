extends ObjectInteractable
class_name MovingObject

@export var move_speed : float = 100

var _origin : Vector2
var _destination : Vector2
@export var DestinationDelta : Vector2

@export var move_on_start: bool = false

var _originFlag : bool = true

func OnInteraction() -> void:
	# print(str(self) + " ON!")
	_originFlag = false
	
func OffInteraction() -> void:
	# print(str(self) + " OFF!")
	_originFlag = true
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_origin = position
	_destination = position + DestinationDelta
	
	_originFlag = not move_on_start

var velocity : Vector2 = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta : float) -> void:
	#const closeToZero : float = 1
	#var desiredRelocation : Vector2 = Vector2.ZERO
#
	#if _originFlag:
		#desiredRelocation = _origin - position
	#else:
		#desiredRelocation = _destination - position

	#if desiredRelocation.length() > closeToZero:
		#position = lerp(position, position + desiredRelocation.normalized(), _acceleration * delta)
	#else:
		#position = lerp(position, desiredRelocation, _acceleration * delta)
		#transform.position = (Vector2)transform.position + desiredRelocation;
		
	var target := _origin if _originFlag else _destination
	var move_dir = abs((target - position).normalized())
	position = Vector2(move_toward(position.x, target.x, move_dir.x * move_speed * delta), move_toward(position.y, target.y, move_dir.y * move_speed * delta))
		
	
	
#func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	#_rb.linear_velocity = velocity
	#transform.position = (Vector2)transform.position + desiredRelocation;
