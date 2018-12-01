extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var animals = ["Cat","Dog","Eagle","Fox","Gecko","Goldfish","Gorilla",
			"Hamster","Lion","Parrot","Puppy","Turtle"]
var animalName
var creationStarted = false #remember to reset this to false!
var animalOffsets
var animalNodes = {}
var animalList
var shopPlacedSprites = []
onready var selArrowNode = get_node("../SelectionArrow")
signal testHagglePlace
func setShopOffsets():
	animalOffsets = {
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
		"legs": get_node("Fox/legs").position,
			#Vector2(295.227997,273.063995) old version
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
func loadAnimalJSON():
	var f = File.new()
	f.open("user://createdanimals.json", File.READ)
	animalList= parse_json(f.get_as_text())
	f.close()
func reduceAnimalSpriteSizes(): #deprecated
	for x in animalNodes:
		for limb in animalNodes[x]:
			animalNodes[x][limb].position *= 0.25
			animalNodes[x][limb].scale *= 0.25
			
func growAnimalSpriteSizes(): #deprecated
	for x in animalNodes:
		for limb in animalNodes[x]:
			animalNodes[x][limb].position *= 4
			animalNodes[x][limb].scale *= 4
	
func assembleAnimalShop(a1,a2,a3,a4):
	var spriteCollect = []
	animalNodes[a1]["body"].z_index = 7
	spriteCollect.append(animalNodes[a1]["body"].duplicate())

	animalNodes[a2]["head"].z_index = 8
	animalNodes[a2]["legs"].z_index = 8
	animalNodes[a2]["head"].position = animalOffsets[a1]["head"]
	#if a2 == "Fox": animalNodes[a2]["legs"].position = animalOffsets[a1]["legs"]-Vector2(3,8)
	#elif a2 == "Gorilla": animalNodes[a2]["legs"].position = animalOffsets[a1]["legs"]-Vector2(0,2)
	#elif a2 == "Penguin": animalNodes[a2]["legs"].position = animalOffsets[a1]["legs"]-Vector2(-1,2)
	#elif a2 == "Hamster":  animalNodes[a2]["legs"].position = animalOffsets[a1]["legs"]-Vector2(0,2)
	#elif a2 == "Turtle": animalNodes[a2]["legs"].position = animalOffsets[a1]["legs"]-Vector2(0,2)
	#elif a2 == "Puppy": animalNodes[a2]["legs"].position = animalOffsets[a1]["legs"]-Vector2(0,1)
	animalNodes[a2]["legs"].position = animalOffsets[a1]["legs"]
	spriteCollect.append(animalNodes[a2]["head"].duplicate())
	spriteCollect.append(animalNodes[a2]["legs"].duplicate())
#offsets facial featuresfor x in animalsNode to the position on their native animals head
#subtracted by the difference between the used head and the a1 head 

	animalNodes[a3]["ears"].z_index = 9
	animalNodes[a3]["mouth"].z_index = 9
	
	if a2 == "Penguin":
		animalNodes[a3]["ears"].position = animalOffsets[a2]["ears"] - (animalOffsets[a2]["head"]-animalOffsets[a1]["head"]) + Vector2(5,21)
	elif a2 == "Gorilla":
		animalNodes[a3]["ears"].position = animalOffsets[a2]["ears"] - (animalOffsets[a2]["head"]-animalOffsets[a1]["head"]) - Vector2(5,5)
	else:
		animalNodes[a3]["ears"].position = animalOffsets[a2]["ears"] - (animalOffsets[a2]["head"]-animalOffsets[a1]["head"])
	animalNodes[a3]["mouth"].position = animalOffsets[a2]["mouth"] - (animalOffsets[a2]["head"]-animalOffsets[a1]["head"])
	spriteCollect.append(animalNodes[a3]["ears"].duplicate())
	spriteCollect.append(animalNodes[a3]["mouth"].duplicate())

	animalNodes[a4]["eyes"].z_index = 10
	animalNodes[a4]["eyes"].position =  animalOffsets[a2]["eyes"] - (animalOffsets[a2]["head"]-animalOffsets[a1]["head"])
	spriteCollect.append(animalNodes[a4]["eyes"].duplicate())
	
	var collectedNode = Node2D.new()
	var bodyOrigPos = spriteCollect[0].position * 0.25
	add_child(collectedNode)
	var haggleNode = Node2D.new()
	add_child(haggleNode)
	for x in spriteCollect:
		haggleNode.add_child(x.duplicate())
		x.set_visible(true)
		x.position *= 0.25
		x.scale *= 0.25
		x.position += selArrowNode.position-bodyOrigPos
		collectedNode.add_child(x)
	shopPlacedSprites.append(collectedNode)
	var haggleBOP = haggleNode.get_child(0).position *.75
	haggleNode.position = Vector2(113.150085, -80.050232)
	for x in haggleNode.get_children():
		x.position *= .75
		x.scale *= .75
		x.set_visible(true)
	haggleNode.set_visible(false)
	get_node("../NPCs").haggleNodes.append(haggleNode)
	print("original pos ", haggleNode)
	emit_signal("testHagglePlace")

func _on_testHaggleDone():
	pass
func _ready():
	connect("testHagglePlace",self,"_on_testHaggleDone")
	#assembles dictionaries of nodes
	for x in self.get_children():
		animalNodes[x.name] = {}
		for y in get_node(x.name).get_children():
			animalNodes[x.name][y.name] = y
	loadAnimalJSON()
	#reduceAnimalSpriteSizes()
	setShopOffsets()
	#assembleAnimalShop("Fox","Cat","Dog","Lion") #leave in for testing

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
