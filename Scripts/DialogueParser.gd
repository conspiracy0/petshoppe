extends Node

var textBox
var textDisplay
var dialogueStream
var currDialogue
var textButton
var characterHeader
var PCneutral
var PCneutralOpen
var PCneutralHalf
var PChappy
var PChappyOpen
var PChappyHalf
var PCsad
var PCsadOpen
var PCsadHalf
var PCthink
var PCthinkOpen
var PCthinkHalf

func _ready():
	pass

func startDialogue(jsonpath):
	#load file as json
	var file = File.new()
	file.open(jsonpath, file.READ)
	var content = (file.get_as_text())
	dialogueStream = parse_json(content)
	file.close()
	#stop movement
	get_node("/root/Shop/PC").canMove = false
	textBox = get_node("../DialogueBox")
	textDisplay = textBox.get_node("Label")
	characterHeader = textBox.get_node("Character")
	textBox.set_visible(true)
	textButton = textBox.get_node("Button")
	loadPCDialogueAnims() #later, only set this to load when a dialogue interaction starts
	scrollText(dialogueStream["intro"])

func stopDialogue():
	textBox.set_visible(false)
	PCsad.set_visible(false)
	PCthink.set_visible(false)
	PChappy.set_visible(false)
	PCneutral.set_visible(false)
	currDialogue = null
	dialogueStream = null
	get_node("/root/Shop/PC").canMove = true

func loadPCDialogueAnims():
	PCneutral = get_node("../PCTalk/PCTalkNeutral")
	PCneutralOpen = PCneutral.get_node("NeutralMouthOpen")
	PCneutralHalf = PCneutral.get_node("NeutralMouthHalf")
	PChappy = get_node("../PCTalk/PCTalkHappy")
	PChappyOpen = PChappy.get_node("HappyOpen")
	PChappyHalf = PChappy.get_node("HappyHalf")
	PCthink = get_node("../PCTalk/PCTalkThink")
	PCthinkOpen = PCthink.get_node("ThinkOpen")
	PCthinkHalf = PCthink.get_node("ThinkHalf")
	PCsad = get_node("../PCTalk/PCTalkSad")
	PCsadOpen = PCsad.get_node("SadOpen")
	PCsadHalf = PCsad.get_node("SadHalf")

func scrollText(jsonfile): #jsonfile should include default path for first dialogue text
	currDialogue = jsonfile
	print(currDialogue["d"][1]["next"])
	var scroller = Timer.new()
	var animCounter = 0
	var PCtalking = false
	var face
	get_node("../DialogueBox/Button").set_visible(false)
	get_node("../DialogueBox/DoneIndicator").set_visible(false)
	#sets up timer
	scroller.set_one_shot(true)
	scroller.set_wait_time(0.02)
	
	textDisplay.set_visible_characters(0) #deletes current text from screen
	textDisplay.set_text(currDialogue["d"][0])	#"d" 0 is ALWAYS the message text
	characterHeader.set_text(currDialogue["d"][1]["character"])
	#identify if it is PC, then do this for each
	if currDialogue["d"][1]["character"] == "Rudy":
		PCtalking = true
		face = currDialogue["d"][1]["face"]
		#despawns old PC sprites
		PCsad.set_visible(false)
		PCneutral.set_visible(false)
		PChappy.set_visible(false)
		PCthink.set_visible(false)
		#initalizes anim with closed mouth
		if face == "neutral":
			PCneutral.set_visible(true) 
		elif face == "happy":
			PChappy.set_visible(true)
		elif face == "think":
			PCthink.set_visible(true)
		else: #sad
			PCsad.set_visible(true)
			
	self.add_child(scroller)
	
	for i in range(currDialogue["d"][0].length()): #gets the max range of string, and iterates displaying each character 1 by 1
		scroller.start() #this is just godots roundabout way of a wait() function, it prints 1 character every 20 ms
		yield(scroller, "timeout")
		textDisplay.set_visible_characters(i)
		if PCtalking == true:
			if i == 0:
				if face == "neutral":
					PCneutralOpen.set_visible(true)
				if face == "happy":
					PChappyOpen.set_visible(true)
				if face == "think":
					PCthinkOpen.set_visible(true)
				else:
					PCsadOpen.set_visible(true)
			animCounter+=1
			#ADJUST THIS DURING NPC DIALOGUE SETUP
			if animCounter == 3:
				PCmouthanim(face, false)
				animCounter = 0
		textDisplay.set_visible_characters(i)
	#ADJUST THIS DURING NPC DIALOGUE SETUP
	if PCtalking == true:
		PCmouthanim(face,true)
	scroller.queue_free()
	get_node("../DialogueBox/Button").set_visible(true)
	get_node("../DialogueBox/DoneIndicator").set_visible(true)
#random selected animation version
func PCmouthanim(Face, isEnd):
	if Face == "neutral":
		if isEnd == true:
			PCneutralOpen.set_visible(false)
			PCneutralHalf.set_visible(false)
			PCneutral.set_visible(true)
			return
		else:
			var randomSelect = randi()%3
			if randomSelect == 0: #closed 
				PCneutralOpen.set_visible(false)
				PCneutralHalf.set_visible(false)
			elif randomSelect == 1: #open
				PCneutralOpen.set_visible(true)
				PCneutralHalf.set_visible(false)
			elif randomSelect == 2:
				PCneutralOpen.set_visible(false)
				PCneutralHalf.set_visible(true)
	if Face == "happy":
		if isEnd == true:
			PChappyOpen.set_visible(false)
			PChappyHalf.set_visible(false)
			PChappy.set_visible(true)
			return
		else:
			var randomSelect = randi()%3
			if randomSelect == 0: #closed 
				PChappyOpen.set_visible(false)
				PChappyHalf.set_visible(false)
			elif randomSelect == 1: #open
				PChappyOpen.set_visible(true)
				PChappyHalf.set_visible(false)
			elif randomSelect == 2:
				PChappyOpen.set_visible(false)
				PChappyHalf.set_visible(true)
	if Face == "think":
		if isEnd == true:
			PCthinkOpen.set_visible(false)
			PCthinkHalf.set_visible(false)
			PCthink.set_visible(true)
			return
		else:
			var randomSelect = randi()%3
			if randomSelect == 0: #closed 
				PCthinkOpen.set_visible(false)
				PCthinkHalf.set_visible(false)
			elif randomSelect == 1: #open
				PCthinkOpen.set_visible(true)
				PCthinkHalf.set_visible(false)
			elif randomSelect == 2:
				PCthinkOpen.set_visible(false)
				PCthinkHalf.set_visible(true)
	else: #sad
		if isEnd == true:
			PCsadOpen.set_visible(false)
			PCsadHalf.set_visible(false)
			PCsad.set_visible(true)
			return
		else:
			var randomSelect = randi()%3
			if randomSelect == 0: #closed 
				PCsadOpen.set_visible(false)
				PCsadHalf.set_visible(false)
			elif randomSelect == 1: #open
				PCsadOpen.set_visible(true)
				PCsadHalf.set_visible(false)
			elif randomSelect == 2:
				PCsadOpen.set_visible(false)
				PCsadHalf.set_visible(true)


func _on_Button_pressed():
	if currDialogue["d"][1]["next"] == "end":
		stopDialogue()
	else:
		#sets and loads next json text dialogue
		scrollText(dialogueStream[currDialogue["d"][1]["next"]])
		