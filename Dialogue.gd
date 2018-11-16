extends Node

var test

func _ready():
	test = get_node("/root/Dialogue/DialogueParser")
	test.startDialogue()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
