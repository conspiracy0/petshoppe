extends Sprite

var isFalling = false
var posCounter = 0
var points = [ #computer
	Vector2(288.84729,104.350143),#dna
	Vector2(438.18689,130.658676) #bed
	]
var pointIndex = 0
var keyReleased = true
onready var labels = [
	get_node("../Labels/DNALabel"),
	get_node("../Labels/BedLabel")
	]
var canSleepFlag = false
var animalList 
func updateLabels():
	if pointIndex == 0:
		labels[0].set_visible(true)
		labels[1].set_visible(false)
	if pointIndex == 1:
		labels[0].set_visible(false)
		labels[1].set_visible(true)
func loadAnimalsJSON():
	var f = File.new()
	f.open("user://createdanimals.json", File.READ)
	animalList= parse_json(f.get_as_text())
	for x in animalList:
		print(x)
		if animalList[x]["inUse"] == true:
			animalList.erase(x)
	var f2 = File.new()
	f2.open("user://createdanimals.json", File.WRITE)
	f2.store_string(JSON.print(animalList," ", false))
	var tempSize = animalList.size()
	if "template" in animalList:
		tempSize -= 1
	if tempSize >= 1:
		canSleepFlag = true
	f.close()
	f2.close()
	
		
func moveSelection():
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_D):
		print("pressed")
		if pointIndex == 1:
			self.position = points[0]
			pointIndex = 0
		else:
			pointIndex += 1
			self.position = points[pointIndex] 
	elif Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_S):
		if pointIndex == 0:
			self.position = points[1]
			pointIndex = 1
		else:
			pointIndex -= 1
			self.position = points[pointIndex]
	updateLabels()
	
func moveToSubScene():
	if Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_F):
		if pointIndex == 0: # open recombinator
			get_tree().change_scene("res://Recombinator.tscn")
		elif pointIndex == 1 and canSleepFlag == true: #sleep
			get_tree().change_scene("res://Shop.tscn")
		elif pointIndex == 1 and canSleepFlag == false:
			get_node("../Labels/Warning").set_visible(true)

func _ready():
	loadAnimalsJSON()

func _process(delta):
	if keyReleased == true:
		moveSelection()
		moveToSubScene()
	#prevents double movement
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_F):
		keyReleased = false
	elif !Input.is_key_pressed(KEY_W) and !Input.is_key_pressed(KEY_D) and !Input.is_key_pressed(KEY_A) and !Input.is_key_pressed(KEY_S) and !Input.is_key_pressed(KEY_ENTER) and !Input.is_key_pressed(KEY_F):
		keyReleased = true
	
	if isFalling == false:
		self.position += Vector2(0,-0.1)
		posCounter -= 0.1
		if posCounter <= -3:
			isFalling = true
	else:
		self.position += Vector2(0,0.1)
		posCounter += 0.1
		if posCounter >= 0:
			isFalling = false