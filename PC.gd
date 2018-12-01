extends KinematicBody2D

var canMove = true
var canInteract = false
var speed = 2 
var lastDirection
var move_direction = Vector2(0,0)
var animalsRaw
var inList = false
var animals = []
var selector = 0
onready var selArrow = get_node("../SelectionArrow")
onready var PCsprite = get_node("AnimatedSprite")
onready var menuLabels = get_node("AnimalMenu/Labels").get_children()
onready var menuArrow = get_node("AnimalMenu/MenuArrow")
onready var animalsNode = get_node("../Animals2")
onready var dialogueNode = get_node("../Dialogue/DialogueParser")
onready var menuBox = get_node("AnimalMenu/MenuBox")
onready var npcNode = get_node("../NPCs")
var menuPressed = false
var animalsForSale = []
var displayBoxPos
var animalsLoaded = false
var enterReleased = true
var animalsEmptyFlag = false
var introFlag = false
var day2Flag = false
var guestCounter = 0
var startingPos = Vector2(98.270302,155.529999)
func _ready():
	
	pass

func _process(delta):
	if canInteract && enterReleased == true:
		beginInteraction()
	if canMove == true and animalsEmptyFlag == false:
		move_player()
	if inList:
		operateList()
	if Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_F):
		enterReleased = false
	elif !Input.is_key_pressed(KEY_ENTER) and !Input.is_key_pressed(KEY_F):
        enterReleased = true
		
func checkForFirstDay():
	var f = File.new()
	f.open("res://dialogue/dayFlag.txt",File.READ_WRITE)
	if f.get_as_text() == "day1":
		#passed day1
		day1Flag = true
		
	
func beginInteraction():
	if menuPressed == false and animalsEmptyFlag == false:
		if Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_F):
			print(animalsEmptyFlag)
			print("began interaction")
			openAnimalList()
			menuPressed = true
	else:
		menuPressed = false
func move_player():
	move_direction = Vector2(0,0)
	if Input.is_key_pressed(KEY_SPACE):
		print(self.global_position)
	if Input.is_key_pressed(KEY_SHIFT):
		speed = 4
	if Input.is_key_pressed(KEY_A):
		move_direction += Vector2(-1,0)
		PCsprite.play("moveside")
		PCsprite.flip_h = true
		lastDirection = "left"
	elif Input.is_key_pressed(KEY_D):
		move_direction += Vector2(1,0)
		PCsprite.play("moveside")
		PCsprite.flip_h = false
		lastDirection = "right"
	elif Input.is_key_pressed(KEY_W):
		move_direction += Vector2(0,-1)
		PCsprite.play("moveback")
		lastDirection = "up"
	elif Input.is_key_pressed(KEY_S):
		move_direction += Vector2(0,1)
		PCsprite.play("movefront")
		lastDirection = "down"
	else:#pc not moving
		if lastDirection == "left" or lastDirection == "right":
			PCsprite.play("idleside")
		elif lastDirection == "up":
			PCsprite.play("idleback")
		else:#pc facing front
			PCsprite.play("idlefront")
	move_and_collide(move_direction.normalized() *speed)

func placeAnimal():
	#assemble sprite and place
	animalsForSale.append(animals[selector])
	animalsRaw[animals[selector]]["inUse"] = true
	var f = File.new()
	f.open("res://animal containers/createdanimals.json",File.WRITE)
	f.store_string(JSON.print(animalsRaw," ", true))
	f.close()
	selArrow.usedPoints.append(selArrow.preHoverPos) #marks the display case as used

	animalsNode.assembleAnimalShop(
		animalsRaw[animals[selector]]["makeup"]["a1"],
		animalsRaw[animals[selector]]["makeup"]["a2"],
		animalsRaw[animals[selector]]["makeup"]["a3"],
		animalsRaw[animals[selector]]["makeup"]["a4"]
		)
		
	#checks to see if there are no more animals, and transitions if so
	for x in animalsRaw:
		if animalsRaw[x]["inUse"] == false:
			animalsEmptyFlag = false
			print("not empty")
			break
		else:
			print("empty")
			animalsEmptyFlag = true
			for x in animalsNode.shopPlacedSprites:
				x.set_visible(false)
			dialogueNode.startDialogue("res://dialogue/intro.json","intro")
	
func loadAnimals():
	if animalsLoaded == false:
		var f = File.new()
		f.open("res://animal containers/createdanimals.json", File.READ)
		animalsRaw = parse_json(f.get_as_text())
		f.close()
		
		for x in animalsRaw:
			if x == "template":
				continue
			if animalsRaw[x]["inUse"] == false:
				animals.append(x)
	
	#for y in animals:
		#print(animalsRaw[y]["makeup"]["body"])
	
	#load sprites
func openAnimalList():
	canInteract = false
	loadAnimals()
	canMove = false
	inList = true
	menuArrow.set_visible(true)
	menuBox.set_visible(true)
	for x in range(animals.size()):
		menuLabels[x].set_text(animals[x])
		menuLabels[x].set_visible(true)
	animalsLoaded = true

func closeAnimalList():
	canMove = true
	inList = false
	menuArrow.set_visible(false)
	menuBox.set_visible(false)
	for x in range(animals.size()):
		menuLabels[x].set_text("")
		menuLabels[x].set_visible(false)
	animals.clear()
	animalsLoaded = false
	
func operateList():
	if Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_F):
		if menuPressed == false:
			print("placed and closed")
			placeAnimal()
			closeAnimalList()
			menuPressed = true
	elif Input.is_key_pressed(KEY_ESCAPE) or Input.is_key_pressed(KEY_X):
		closeAnimalList()
	elif Input.is_key_pressed(KEY_S):
		if selector+1 <= animals.size()-1:
			if menuPressed == false:
				selector += 1
				menuArrow.position += Vector2(0,43)
				menuPressed = true
	elif Input.is_key_pressed(KEY_W):
		if menuPressed == false:
			if selector-1 >= 0:
				selector -= 1
				menuArrow.position -= Vector2(0,43)
				menuPressed = true
	elif Input.is_key_pressed(KEY_D):
		if menuPressed == false:
			if selector+8 <= animals.size()-1:
				selector += 8
				menuArrow.position += Vector2(213,0)
				menuPressed = true
	elif Input.is_key_pressed(KEY_A):
		if menuPressed == false:
			if selector-8 >= 0:
				selector -= 8
				menuArrow.position -= Vector2(213,0)
				menuPressed = true
	else: #only allows one movement per keystroke
		menuPressed = false
	

##DISPLAY SELECTION FUNCTIONS
#display case 1
func _on_BoxRight_body_entered(body):
	if body.get_name() == "PC":
		selArrow.changeLocation(1,"right")

func _on_BoxLeft_body_entered(body):
	print("dc1left entered")
	if body.get_name() == "PC":
		selArrow.changeLocation(1,"left")

func _on_BoxLeft2_body_entered(body):
	print("dc1left2entered")
	if body.get_name() == "PC":
		selArrow.changeLocation(1,"left2")

func _on_BoxRight2_body_entered(body):
	if body.get_name() == "PC":
		selArrow.changeLocation(1,"right2")

#display case 2
func _on_DC2BoxLeft_body_entered(body):
	if body.get_name() == "PC":
		selArrow.changeLocation(2,"left")

func _on_DC2BoxMiddle_body_entered(body):
	if body.get_name() == "PC":
		selArrow.changeLocation(2,"middle")

func _on_DC2BoxRight_body_entered(body):
	if body.get_name() == "PC":
		selArrow.changeLocation(2,"right")

#display case 3

func _on_DC3BoxMiddleBot_body_entered(body):
	if body.get_name() == "PC":
		selArrow.changeLocation(3,"middlebot")

func _on_DC3BoxMiddleTop_body_entered(body):
	if body.get_name() == "PC":
		selArrow.changeLocation(3,"middletop")

func _on_DC3Left2_body_entered(body):
	if body.get_name() == "PC":
		selArrow.changeLocation(3,"left2")

func _on_DC3Right2_body_entered(body):
	if body.get_name() == "PC":
		selArrow.changeLocation(3,"right2")

func _on_DC3Left_body_entered(body):
	if body.get_name() == "PC":
		selArrow.changeLocation(3,"left")

func _on_DC3Right_body_entered(body):
	if body.get_name() == "PC":
		selArrow.changeLocation(3,"right")
		
#display case 4
func _on_DC4Solo_body_entered(body):
	if body.get_name() == "PC":
		selArrow.changeLocation(4,"solo")
		
#display case 5
func _on_DC5Bottom_body_entered(body):
	if body.get_name() == "PC":
		selArrow.changeLocation(5,"bottom")

func _on_DC5Top_body_entered(body):
	if body.get_name() == "PC":
		selArrow.changeLocation(5,"top")


func _on_DialogueParser_dialogue_ended():
	#for x in animalsNode.shopPlacedSprites:
	#	x.set_visible(true)
	self.position = startingPos
	if introFlag == false:
		npcNode.get_node("Child").enterBuilding()
		introFlag = true
