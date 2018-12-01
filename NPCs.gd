extends Node

onready var haggleMenu = get_node("HaggleMenu")
onready var hmMain = get_node("HaggleMenu/Main")
onready var hmMarkup = get_node("HaggleMenu/Markup")
onready var hmPrice = get_node("HaggleMenu/Price")
onready var hmCost = get_node("HaggleMenu/Cost")
onready var animalsNode = get_node("../Animals2")
onready var PCnode = get_node("../PC")
onready var PCdialogueNode = get_node("../Dialogue/PCTalk/PCTalkNeutral")
onready var girlNode = get_node("ChildClose")
onready var girlHappyNode = get_node("ChildCloseHappy")
onready var girlUpsetNode = get_node("ChildCloseUpset")
onready var dialogueParseNode = get_node("../Dialogue/DialogueParser")
var haggleNodes =[]
var offerClickable = false
var markupUpClickable = false
var markupDownClickable = false
var girlLimit = 160
var limitWithRand
var declineCounter = 0
var leavingFlag = false
var enteringFlag = false
var inHaggle = false
var refusedFlag = false

func initPrice(cost):
	hmCost.text = "$" + str(cost)
	hmPrice.text = "$" + str(cost)
	hmMarkup.text = "100%"
func startHaggle():
	inHaggle = true
	initPrice(PCnode.costsForNPCNode[int(PCnode.guestCounter)])
	for x in animalsNode.shopPlacedSprites:
		x.set_visible(false)
	haggleMenu.set_visible(true)
	PCdialogueNode.set_visible(true)
	PCnode.canMove = false
	haggleNodes[PCnode.guestCounter].set_visible(true)
	girlNode.set_visible(true)
	dialogueParseNode.inHaggleFlag = true
	dialogueParseNode.startDialogue("res://dialogue/haggleTest.json","greet")
	print("dialoguePassed")
	updateLimit()
func adjustPrice(direction):
	var muPercent = float(hmMarkup.text.substr(0,3))/100
	var costNum = float(hmCost.text.substr(1,3))
	if direction == "up": muPercent += 0.1
	elif direction == "down": muPercent -= 0.1
	if muPercent*costNum <= 0:
		hmMarkup.text = "0%"
		hmPrice.text = "$0"
	else:
		hmMarkup.text = str(muPercent*100)+"%"
		hmPrice.text = "$" + str(costNum*muPercent)
func stopHaggle(moneyAdded):
	print("stopHaggle")
	declineCounter = 0
	if refusedFlag == false:
		PCnode.money += moneyAdded
	haggleMenu.set_visible(false)
	PCdialogueNode.set_visible(false)
	girlNode.set_visible(false)
	girlUpsetNode.set_visible(false)
	girlHappyNode.set_visible(false)
	dialogueParseNode.inHaggleFlag = false
	haggleNodes[PCnode.guestCounter].set_visible(false)
	dialogueParseNode.stopDialogue()
	get_node("Child").exitMovementActive = true
	for x in animalsNode.shopPlacedSprites:
		x.set_visible(true)
	
func _ready():
	pass
func updateLimit():
	limitWithRand = (girlLimit + rand_range(-40,40))
func _input(event):
	if event is InputEventMouseButton and event.pressed == true and inHaggle == true:
		if offerClickable == true:
			print(limitWithRand)
			var muPercentRaw = float(hmMarkup.text.substr(0,3))
			#positive numbers mean over limit, negative ones mean under limit
			var margin = muPercentRaw - limitWithRand
			var price = float(hmPrice.text.substr(1,3))
			if margin <= -40:
				dialogueParseNode.startDialogue("res://dialogue/haggleTest.json","happyAccept")
				yield(dialogueParseNode,"line_ended")
				stopHaggle(price)
			elif margin <= -20:
				dialogueParseNode.startDialogue("res://dialogue/haggleTest.json","neutralAccept")
				yield(dialogueParseNode,"line_ended")
				stopHaggle(price)
			elif margin <= 0:
				dialogueParseNode.startDialogue("res://dialogue/haggleTest.json","sadAccept")
				yield(dialogueParseNode,"line_ended")
				stopHaggle(price)
			elif margin <= 40:
				declineCounter += 1
				if declineCounter == 3:
					dialogueParseNode.startDialogue("res://dialogue/haggleTest.json","threeDeclines")
					yield(dialogueParseNode,"line_ended")
					refusedFlag = true
					stopHaggle(price)
				else:
					dialogueParseNode.startDialogue("res://dialogue/haggleTest.json","smallDecline")
			else:
				dialogueParseNode.startDialogue("res://dialogue/haggleTest.json","largeDecline")
				refusedFlag = true
				yield(dialogueParseNode, "line_ended")
				stopHaggle(price)
			offerClickable = false
			inHaggle = false
			refusedFlag = false
				
		elif markupDownClickable == true:
			adjustPrice("down")
		elif markupUpClickable == true:
			adjustPrice("up")


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Offer_mouse_entered():
	offerClickable = true


func _on_Offer_mouse_exited():
	offerClickable = false

func _on_MarkupUp_mouse_entered():
	markupUpClickable = true

func _on_MarkupUp_mouse_exited():
	markupUpClickable = false

func _on_MarkupDown_mouse_entered():
	markupDownClickable = true

func _on_MarkupDown_mouse_exited():
	markupDownClickable = false
