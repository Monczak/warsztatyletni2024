extends Resource
class_name Interaction

enum InteractionMode { SetOn, SetOff }
enum TriggerMode { OnInteractionStarted, OnInteractionEnded, Both }

@export var interactable: NodePath
@export var mode: InteractionMode = InteractionMode.SetOn
@export var trigger_mode: TriggerMode = TriggerMode.Both


func _perform_interaction(interactable_obj: ObjectInteractable, negate: bool) -> void:
	if (mode == InteractionMode.SetOn) != negate:
		interactable_obj.OnInteraction()
	else:
		interactable_obj.OffInteraction()


func do_interaction(context: Node, turn_on: bool) -> void:
	var interactable_obj: ObjectInteractable = context.get_node(interactable)
	if turn_on:
		if trigger_mode == TriggerMode.OnInteractionStarted or trigger_mode == TriggerMode.Both: 
			_perform_interaction(interactable_obj, false)
	else:
		if trigger_mode == TriggerMode.OnInteractionEnded or trigger_mode == TriggerMode.Both: 
			_perform_interaction(interactable_obj, true)
