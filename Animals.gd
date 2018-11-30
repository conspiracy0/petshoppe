extends Node

var animals = ["Cat","Dog","Eagle","Fox","Gecko","Goldfish","Gorilla",
			"Hamster","Lion","Parrot","Puppy","Turtle"]
var animalName
var creationStarted = false #remember to reset this to false!
onready var animalOffsets = {
	"Cat" : {
		"body": get_node("Cat/body").position,
		"head": get_node("Cat/head").position,
		"eyes": get_node("Cat/eyes").position,
		"mouth": get_node("Cat/mouth").position,
		"ears": get_node("Cat/ears").position,
		"legs": get_node("Cat/legs").position,
		},
	"Dog": {
		"body": get_node("Dog/body").position,
		"head": get_node("Dog/head").position,
		"eyes": get_node("Dog/eyes").position,
		"mouth": get_node("Dog/mouth").position,
		"ears": get_node("Dog/ears").position,
		"legs": get_node("Dog/legs").position,
		},
	"Eagle": {
		"body": get_node("Eagle/body").position,
		"head": get_node("Eagle/head").position,
		"eyes": get_node("Eagle/eyes").position,
		"mouth": get_node("Eagle/mouth").position,
		"ears": get_node("Eagle/ears").position,
		"legs": get_node("Eagle/legs").position,
		},
	"Fox": {
		"body": get_node("Fox/body").position,
		"head": get_node("Fox/head").position,
		"eyes": get_node("Fox/eyes").position,
		"mouth": get_node("Fox/mouth").position,
		"ears": get_node("Fox/ears").position,
		"legs": Vector2(295.227997,273.063995)
		},
	"Gecko": {
		"body": get_node("Gecko/body").position,
		"head": get_node("Gecko/head").position,
		"eyes": get_node("Gecko/eyes").position,
		"mouth": get_node("Gecko/mouth").position,
		"ears": get_node("Gecko/ears").position,
		"legs": get_node("Gecko/legs").position,
		},
	"Goldfish": {
		"body": get_node("Goldfish/body").position,
		"head": get_node("Goldfish/head").position,
		"eyes": get_node("Goldfish/eyes").position,
		"mouth": get_node("Goldfish/mouth").position,
		"ears": get_node("Goldfish/ears").position,
		"legs": get_node("Goldfish/legs").position,
		},
	"Gorilla":{
		"body": get_node("Gorilla/body").position,
		"head": get_node("Gorilla/head").position,
		"eyes": get_node("Gorilla/eyes").position,
		"mouth": get_node("Gorilla/mouth").position,
		"ears": get_node("Gorilla/ears").position,
		"legs": get_node("Gorilla/legs").position,
		},
	"Hamster":{
		"body": get_node("Hamster/body").position,
		"head": get_node("Hamster/head").position,
		"eyes": get_node("Hamster/eyes").position,
		"mouth": get_node("Hamster/mouth").position,
		"ears": get_node("Hamster/ears").position,
		"legs": get_node("Hamster/legs").position,
		},
	"Lion":{
		"body": get_node("Lion/body").position,
		"head": get_node("Lion/head").position,
		"eyes": get_node("Lion/eyes").position,
		"mouth": get_node("Lion/mouth").position,
		"ears": get_node("Lion/ears").position,
		"legs": get_node("Lion/legs").position,
		},
	"Parrot":{
		"body": get_node("Parrot/body").position,
		"head": get_node("Parrot/head").position,
		"eyes": get_node("Parrot/eyes").position,
		"mouth": get_node("Parrot/mouth").position,
		"ears": get_node("Parrot/ears").position,
		"legs": get_node("Parrot/legs").position,
		},
	"Penguin":{
		"body": get_node("Penguin/body").position,
		"head": get_node("Penguin/head").position,
		"eyes": get_node("Penguin/eyes").position,
		"mouth": get_node("Penguin/mouth").position,
		"ears": get_node("Penguin/ears").position,
		"legs": get_node("Penguin/legs").position,
		},
	"Puppy":{
		"body": get_node("Puppy/body").position,
		"head": get_node("Puppy/head").position,
		"eyes": get_node("Puppy/eyes").position,
		"mouth": get_node("Puppy/mouth").position,
		"ears": get_node("Puppy/ears").position,
		"legs": get_node("Puppy/legs").position,
		},
	"Turtle":{
		"body": get_node("Turtle/body").position,
		"head": get_node("Turtle/head").position,
		"eyes": get_node("Turtle/eyes").position,
		"mouth": get_node("Turtle/mouth").position,
		"ears": get_node("Turtle/ears").position,
		"legs": get_node("Turtle/legs").position,
		}
	}
var animalNodes = {}
var animalList
signal limitReached
onready var PCnode = get_node("../Background/PC")
onready var RCnode = get_node("../Background/Recombinator")
onready var nameNode = get_node("../NameEntry")
onready var machineNode = get_node("../Machine")
onready var starNode = get_node("../StarAnim")
onready var DNALabels = [
	get_node("../DNADisplay/DNA1"),
	get_node("../DNADisplay/DNA2"),
	get_node("../DNADisplay/DNA3"),
	get_node("../DNADisplay/DNA4"),
	get_node("../DNADisplay/DNA5"),
	get_node("../DNADisplay/DNA6"),
	get_node("../DNADisplay/DNA7"),
	get_node("../DNADisplay/DNA8"),
	get_node("../DNADisplay/DNA9"),
	get_node("../DNADisplay/DNA10"),
	get_node("../DNADisplay/DNA11"),
	get_node("../DNADisplay/DNA12"),
	get_node("../DNADisplay/DNA13")
	]
func seeAllCombos():
	var scroller = Timer.new()
	scroller.set_one_shot(true)
	scroller.set_wait_time(3)
	self.add_child(scroller)
	for x in animalNodes:
		assembleAnimal("Fox",x,"Fox","Fox")
		scroller.start() #this is just godots roundabout way of a wait() function, it prints 1 character every 20 ms
		yield(scroller, "timeout")
		animalNodes[x]["head"].set_visible(false)
		animalNodes[x]["legs"].set_visible(false)
	scroller.queue_free()
func loadDNANames():
	for i in range(12):
		DNALabels[i].text = animals[i]
func loadAnimalJSON():
	var f = File.new()
	f.open("res://animal containers/createdanimals.json", File.READ)
	animalList= parse_json(f.get_as_text())
	if animalList.size() == 15:
		get_node("../Warning").set_visible(true)
	f.close()
func saveAnimalJSON():
	var f = File.new()
	f.open("res://animal containers/createdanimals.json",File.WRITE)
	f.store_string(JSON.print(animalList," ", true))
	f.close()
func assembleAnimal(a1,a2,a3,a4):
	machineNode.animPlayingFlag = true
	PCnode.play("watch")
	RCnode.play("activate")
	yield(RCnode, "animation_finished")
	PCnode.play("idle1")
	RCnode.play("idle")
	starNode.set_visible(true)
	starNode.play("start")
	yield(starNode,"animation_finished")
	starNode.play("idle")
	starNode.get_node("NameIt").set_visible(true)
	
	animalNodes[a1]["body"].set_visible(true)
	animalNodes[a1]["body"].z_index = 7
		
	animalNodes[a2]["head"].set_visible(true)
	animalNodes[a2]["legs"].set_visible(true)
	animalNodes[a2]["head"].z_index = 8
	animalNodes[a2]["legs"].z_index = 8
	animalNodes[a2]["head"].position = animalOffsets[a1]["head"]
	if a2 == "Fox": animalNodes[a2]["legs"].position = animalOffsets[a1]["legs"]-Vector2(3,8)
	elif a2 == "Gorilla": animalNodes[a2]["legs"].position = animalOffsets[a1]["legs"]-Vector2(0,2)
	elif a2 == "Penguin": animalNodes[a2]["legs"].position = animalOffsets[a1]["legs"]-Vector2(-1,2)
	elif a2 == "Hamster":  animalNodes[a2]["legs"].position = animalOffsets[a1]["legs"]-Vector2(0,2)
	elif a2 == "Turtle": animalNodes[a2]["legs"].position = animalOffsets[a1]["legs"]-Vector2(0,2)
	elif a2 == "Puppy": animalNodes[a2]["legs"].position = animalOffsets[a1]["legs"]-Vector2(0,1)
	else: animalNodes[a2]["legs"].position = animalOffsets[a1]["legs"]
#offsets facial features to the position on their native animals head
#subtracted by the difference between the used head and the a1 head 

	animalNodes[a3]["ears"].z_index = 9
	animalNodes[a3]["mouth"].z_index = 9
	animalNodes[a3]["ears"].set_visible(true)
	animalNodes[a3]["mouth"].set_visible(true)
	if a2 == "Penguin":
		animalNodes[a3]["ears"].position = animalOffsets[a2]["ears"] - (animalOffsets[a2]["head"]-animalOffsets[a1]["head"]) + Vector2(5,21)
	elif a2 == "Gorilla":
		animalNodes[a3]["ears"].position = animalOffsets[a2]["ears"] - (animalOffsets[a2]["head"]-animalOffsets[a1]["head"]) - Vector2(5,5)
	else:
		animalNodes[a3]["ears"].position = animalOffsets[a2]["ears"] - (animalOffsets[a2]["head"]-animalOffsets[a1]["head"])
	animalNodes[a3]["mouth"].position = animalOffsets[a2]["mouth"] - (animalOffsets[a2]["head"]-animalOffsets[a1]["head"])

	animalNodes[a4]["eyes"].set_visible(true)
	animalNodes[a4]["eyes"].z_index = 10
	animalNodes[a4]["eyes"].position =  animalOffsets[a2]["eyes"] - (animalOffsets[a2]["head"]-animalOffsets[a1]["head"])
	
	#name input
	
	nameNode.set_visible(true)
	machineNode.animalNamingFlag = true
	yield(machineNode, "nameEntered")
	print("got past yield")
	animalName = nameNode.text
	nameNode.clear()
	nameNode.set_visible(false)
	animalNodes[a4]["eyes"].set_visible(false)
	animalNodes[a3]["ears"].set_visible(false)
	animalNodes[a3]["mouth"].set_visible(false)
	animalNodes[a2]["head"].set_visible(false)
	animalNodes[a2]["legs"].set_visible(false)
	animalNodes[a1]["body"].set_visible(false)
	animalList[animalName] = {}
	animalList[animalName]["makeup"] = {}
	animalList[animalName]["makeup"]["body"] = a1
	animalList[animalName]["makeup"]["head"] = a2
	animalList[animalName]["makeup"]["legs"] = a2
	animalList[animalName]["makeup"]["ears"] = a3
	animalList[animalName]["makeup"]["mouth"] = a3
	animalList[animalName]["makeup"]["eyes"] = a4
	animalList[animalName]["inUse"] = false
	saveAnimalJSON()
	if animalList.size() == 15:
		get_node("../Warning").set_visible(true)
	if animalList.size() == 16:
		emit_signal("limitReached")
		

func _ready():
	#assembles dictionaries of nodes
	for x in self.get_children():
		animalNodes[x.name] = {}
		for y in get_node(x.name).get_children():
			animalNodes[x.name][y.name] = y
	loadAnimalJSON()
	loadDNANames()
	seeAllCombos()
	connect("limitReached", self, "onLimitReached")

func onLimitReached(): 
	#scene transition
	print("limit reached")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

