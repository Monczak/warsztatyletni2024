extends Resource
class_name TimerConnection

enum ConnectionMode {
	SetOn, SetOff, Toggle
}

@export var interactable: NodePath
@export var mode: ConnectionMode
@export_range(0.0, 1.0) var phase_shift: float
