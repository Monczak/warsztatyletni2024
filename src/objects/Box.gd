extends PlayerInteractable
class_name Box


func on_interaction():
	super.on_interaction()
	print("On Interaction!")


func off_interaction():
	super.off_interaction()
	print("Off Interaction!")
