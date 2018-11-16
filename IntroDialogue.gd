extends Node
var introStream

onready var dparser = get_node("../DialogueParser")

func _ready():
	dparser.startDialogue("res://dialogue/intro.json")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
