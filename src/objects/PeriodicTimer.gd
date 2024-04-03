extends ObjectInteractable
class_name PeriodicTimer

@export_range(0.1, 60.0) var cycle_time: float
@export var connections: Array[TimerConnection] = []

@onready var _timer: Timer = $Timer

var _connection_handled: Dictionary
var _connection_states: Dictionary

var _timed_out := false


func _reset_connections() -> void:
	for connection in connections:
		_connection_handled[connection] = false


func _start_cycle() -> void:
	_reset_connections()
	_timer.start(cycle_time)  
	_timed_out = false


func _ready() -> void:
	_timer.timeout.connect(_on_timeout)
	_start_cycle()


func _process(delta: float) -> void:
	var time_in_cycle: float = cycle_time - _timer.time_left
	
	for connection in connections:
		if time_in_cycle >= connection.phase_shift * cycle_time:
			_handle_connection(connection)

	if _timed_out:
		_start_cycle()
	

func _handle_connection(connection: TimerConnection) -> void:
	if _connection_handled[connection]:
		return

	var interactable: ObjectInteractable = get_node(connection.interactable)
	match connection.mode:
		TimerConnection.ConnectionMode.SetOn:
			interactable.OnInteraction()
		TimerConnection.ConnectionMode.SetOff:
			interactable.OffInteraction()
		TimerConnection.ConnectionMode.Toggle:
			if _connection_states.get_or_add(interactable) == null or not _connection_states[interactable]:
				_connection_states[interactable] = true
				interactable.OnInteraction()
			else:
				_connection_states[interactable] = false
				interactable.OffInteraction()
	
	_connection_handled[connection] = true


func _on_timeout() -> void:
	_timed_out = true
