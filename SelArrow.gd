extends Sprite

var isFalling = false
var posCounter = 0
var points = [
	Vector2(79.152847,259.879944), #computer
	Vector2(288.84729,104.350143),#dna
	Vector2(438.18689,130.658676) #bed
	]
var pointIndex = 0
var keyReleased = true
onready var labels = [
	get_node("../Labels/CompLabel"),
	get_node("../Labels/DNALabel"),
	get_node("../Labels/BedLabel")
	]

func updateLabels():
	if pointIndex == 0:
		labels[0].set_visible(true)
		labels[1].set_visible(false)
		labels[2].set_visible(false)
	if pointIndex == 1:
		labels[0].set_visible(false)
		labels[1].set_visible(true)
		labels[2].set_visible(false)
	if pointIndex == 2:
		labels[0].set_visible(false)
		labels[1].set_visible(false)
		labels[2].set_visible(true)
		
func moveSelection():
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_D):
		print("pressed")
		if pointIndex == 2:
			self.position = points[0]
			pointIndex = 0
		else:
			pointIndex += 1
			self.position = points[pointIndex] 
	elif Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_S):
		if pointIndex == 0:
			self.position = points[2]
			pointIndex = 2
		else:
			pointIndex -= 1
			self.position = points[pointIndex]
	updateLabels()
	
func moveToSubScene():
	if Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_F):
		if pointIndex == 0: # open computer
			return
		elif pointIndex == 1: #open recombinator
			return 
		else: #open bed
			return

func _ready():
	pass

func _process(delta):
	if keyReleased == true:
		moveSelection()
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