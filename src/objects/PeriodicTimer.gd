extends ObjectInteractable
class_name PeriodicTimer

@export_range(0.1, 60.0) var cycle_time: float
@export var connections: Array[TimerConnection] = []

var _time := 0.0
var _paused := false

var _connection_handled: Dictionary
var _connection_states: Dictionary

var _timed_out := false

enum TimerBehavior { Start, Pause, Unpause, Reset }

enum ToggleResetMode { LastToggledState, ForceOn, ForceOff }

@export var loop := true
@export var on_interaction_behavior := TimerBehavior.Start
@export var off_interaction_behavior := TimerBehavior.Reset

@export var initial_behavior := TimerBehavior.Start
@export var toggle_reset_mode := ToggleResetMode.ForceOff

@onready var sprite: Sprite2D = $Sprite2D

var _frame_count = 8

var _scheduled_behavior = null


func _do_behavior(behavior: TimerBehavior) -> void:
	match behavior:
		TimerBehavior.Start:
			_start_cycle()
		TimerBehavior.Pause:
			_pause_cycle()
		TimerBehavior.Unpause:
			_unpause_cycle()
		TimerBehavior.Reset:
			_reset_cycle()


func _reset_connections() -> void:
	for connection in connections:
		_connection_handled[connection] = false
		

func _reset_interactables() -> void:
	for connection in connections:
		_reset_interactable(connection)


func _start_cycle() -> void:
	_paused = false
	_reset_connections()
	_time = 0
	_timed_out = false
	
	# print("Start")


func _pause_cycle() -> void:
	_paused = true
	# print("Pause")
	
	
func _unpause_cycle() -> void:
	_paused = false
	# print("Unpause")


func _reset_cycle() -> void:
	_time = 0
	_paused = true
	_reset_interactables()
	# print("Reset")


func OnInteraction() -> void:
	_scheduled_behavior = on_interaction_behavior
	
	
func OffInteraction() -> void:
	_scheduled_behavior = off_interaction_behavior


func _ready() -> void:
	_do_behavior(initial_behavior)
	
	for connection in connections:
		_connection_handled[connection] = null


func _process(delta: float) -> void:		
	if not _paused:
		_time += delta
		for connection in connections:
			if _time >= connection.phase_shift * cycle_time:
				_handle_connection(connection)
				
		if _time > cycle_time and loop:
			_start_cycle()
			
	sprite.frame = int(floor(inverse_lerp(0, _frame_count - 0.01, _time / cycle_time)))
	
	if _scheduled_behavior != null:
		_do_behavior(_scheduled_behavior)
		_scheduled_behavior = null
		
	# print(time_in_cycle)
	
func _set_state(interactable: ObjectInteractable, on: bool) -> void:
	_connection_states[interactable] = on
	if on:
		interactable.OnInteraction()
	else:
		interactable.OffInteraction()


func _handle_connection(connection: TimerConnection) -> void:
	if _connection_handled[connection]:
		return
		
	# print("Handle " + str(connection))

	var interactable: ObjectInteractable = get_node(connection.interactable)
	match connection.mode:
		TimerConnection.ConnectionMode.SetOn:
			_set_state(interactable, true)
		TimerConnection.ConnectionMode.SetOff:
			_set_state(interactable, false)
		TimerConnection.ConnectionMode.Toggle:
			if _connection_states.get_or_add(interactable) == null or not _connection_states[interactable]:
				_set_state(interactable, true)
			else:
				_set_state(interactable, false)
	
	_connection_handled[connection] = true


func _reset_interactable(connection: TimerConnection) -> void:
	var interactable: ObjectInteractable = get_node(connection.interactable)
	match connection.mode:
		TimerConnection.ConnectionMode.SetOn:
			_set_state(interactable, false)
		TimerConnection.ConnectionMode.SetOff:
			_set_state(interactable, true)
		TimerConnection.ConnectionMode.Toggle:
			match toggle_reset_mode:
				ToggleResetMode.ForceOn:
					_set_state(interactable, true)
				ToggleResetMode.ForceOff:
					_set_state(interactable, false)
				ToggleResetMode.LastToggledState:
					if _connection_states.get(interactable) == null:
						return
					
					if _connection_states[interactable]:
						_set_state(interactable, false)
					else:
						_set_state(interactable, true)
