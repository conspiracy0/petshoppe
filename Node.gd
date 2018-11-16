extends Node

onready var dparser = get_node("../DialogueParser")

func _ready():
	dparser.startDialogue()
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
