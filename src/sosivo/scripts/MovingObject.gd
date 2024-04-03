extends ObjectInteractable
class_name MovingObject
@export var rb: RigidBody2D
@export var DestinationDelta: Vector2 = Vector2.ZERO
@export var maxStrength: float = 0
@export var maxSpeed = 0
var _origin : Vector2 = Vector2.ZERO
var _destination : Vector2 = Vector2.ZERO
@export var _originFlag : bool = true
var _timeSinceSwitch :float = 0;

func OnInteraction() -> void:
	# print(str(self) + " ON!")
	_originFlag = false
	
func OffInteraction() -> void:
	# print(str(self) + " OFF!")
	_originFlag = true
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_origin = position
	_destination = _origin + DestinationDelta
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:		
	var destination : Vector2 = Vector2.ZERO
	if(_originFlag):
		modulate = Color.RED
		destination = _origin
	else:
		modulate = Color.GREEN
		destination = _destination		
	
	var desiredOffset =(destination-position)
	var desiredMomentum = (desiredOffset*rb.mass/delta);
	if(desiredMomentum.length() > maxSpeed * rb.mass):
		desiredMomentum = desiredMomentum.normalized() * maxSpeed * rb.mass
	var desiredImpulse = (desiredMomentum-rb.linear_velocity*rb.mass)
	if(desiredImpulse.length() > maxStrength):
		desiredImpulse = desiredImpulse.normalized()*maxStrength
	
	rb.apply_central_impulse(desiredImpulse)
	pass
