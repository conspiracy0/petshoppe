extends Node

var animals = ["Cat","Dog","Eagle","Fox","Gecko","Goldfish","Gorilla",
			"Hamster","Lion","Parrot","Penguin","Puppy","Turtle"]
var animalName
var creationStarted = false #remember to reset this to false!
var animalOffsets = {
	"Cat" : {
		"body": Vector2(294.80954,181.064117),
		"head": Vector2(335.177094,165.398331),
		"eyes": Vector2(353.035736,159.290329),
		"mouth": Vector2(363.035736,174.290329),
		"ears": Vector2(337.80954,134.064117),
		"legs": Vector2(312.80954,250.064117)
		},
	"Dog": {
		"body": Vector2(303.80954, 195.064117), 
		"head": Vector2(340.685425,154.258286),
		"eyes": Vector2(349.544067,148.150284),
		"mouth": Vector2(362.544067,173.150284),
		"ears": Vector2(333.317871,121.924072),
		"legs": Vector2(306.227661,240.064117)
		},
	"Eagle": {
		"body": Vector2(303.81, 182.064),
		"head": Vector2( 323.685, 158.258 ),
		"eyes": Vector2( 339.544, 146.15 ),
		"mouth": Vector2( 356.544, 169.15 ),
		"ears": Vector2( 328.318, 131.924 ),
		"legs": Vector2( 296.149, 243.824 )
		},
	"Fox": {
		"body": Vector2( 292.81, 195.064 ),
		"head": Vector2( 343.032, 162.985 ),
		"eyes": Vector2( 347.544, 163.15 ),
		"mouth": Vector2( 359.544, 182.15 ),
		"ears": Vector2( 335.318, 139.924 ),
		"legs": Vector2( 304.80954, 260.064117)
		}
	}
var animalNodes = {}
var animalList
signal limitReached
onready var PCnode = get_node("../Background/PC")
onready var RCnode = get_node("../Background/Recombinator")
onready var nameLabel = get_node("../NameLabel")
onready var nameNode = get_node("../NameEntry")
onready var machineNode = get_node("../Machine")
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
func loadDNANames():
	for i in range(13):
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
		
	animalNodes[a1]["body"].set_visible(true)
	animalNodes[a1]["body"].z_index = 7
		
	animalNodes[a2]["head"].set_visible(true)
	animalNodes[a2]["legs"].set_visible(true)
	animalNodes[a2]["head"].z_index = 8
	animalNodes[a2]["legs"].z_index = 8
	animalNodes[a2]["head"].position = animalOffsets[a1]["head"]
	if a2 == "Fox": animalNodes[a2]["legs"].position = animalOffsets[a1]["legs"]-Vector2(3,8)
	else: animalNodes[a2]["legs"].position = animalOffsets[a1]["legs"]
#offsets facial features to the position on their native animals head
#subtracted by the difference between the used head and the a1 head 

	animalNodes[a3]["ears"].z_index = 9
	animalNodes[a3]["mouth"].z_index = 9
	animalNodes[a3]["ears"].set_visible(true)
	animalNodes[a3]["mouth"].set_visible(true)
	animalNodes[a3]["ears"].position = animalOffsets[a2]["ears"] - (animalOffsets[a2]["head"]-animalOffsets[a1]["head"])
	animalNodes[a3]["mouth"].position = animalOffsets[a2]["mouth"] - (animalOffsets[a2]["head"]-animalOffsets[a1]["head"])

	animalNodes[a4]["eyes"].set_visible(true)
	animalNodes[a4]["eyes"].z_index = 10
	animalNodes[a4]["eyes"].position =  animalOffsets[a2]["eyes"] - (animalOffsets[a2]["head"]-animalOffsets[a1]["head"])
	
	#name input
	
	nameNode.set_visible(true)
	nameLabel.set_visible(true)
	machineNode.animalNamingFlag = true
	yield(machineNode, "nameEntered")
	print("got past yield")
	animalName = nameNode.text
	nameNode.clear()
	nameNode.set_visible(false)
	nameLabel.set_visible(false)
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
	connect("limitReached", self, "onLimitReached")

func onLimitReached(): 
	#scene transition
	print("limit reached")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

