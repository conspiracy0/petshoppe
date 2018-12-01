extends Sprite

onready var sliders = [
	get_node("SliderTube1"),
	get_node("SliderTube2"),
	get_node("SliderTube3"),
	get_node("SliderTube4")
	]
onready var tubes = [
	get_node("TestTube1"),
	get_node("TestTube2"),
	get_node("TestTube3"),
	get_node("TestTube4")
	]
onready var lockers = [
	get_node("LockerArea/Locked1"),
	get_node("LockerArea2/Locked2"),
	get_node("LockerArea3/Locked3"),
	get_node("LockerArea4/Locked4"),
	]
var slidersBool = [
	false, #1
	false, #2
	false, #3
	false, #4
	]
onready var tubeLabels = [
	get_node("LabelTube1"),
	get_node("LabelTube2"),
	get_node("LabelTube3"),
	get_node("LabelTube4")
	]
onready var boxLabels = [
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

signal nameEntered
var boxLabelReady = [false,false,false,false,false,false,false,false,false,false,false,false,false]
var labelReady = [false,false,false,false]
onready var animalsNode = get_node("../Animals")
onready var goButton = get_node("Go")
onready var resetButton = get_node("Reset")
onready var displayDNANode = get_node("../DNADisplay")
onready var PCnode = get_node("../Background/PC")
var resetReady = false
var goReady = false
var lockersSelected = [false, false, false, false]
var slidersLocked = [ false, false, false, false]
var tubeSliderDist = 154.110275
var tallSliderBounds = [383.486084,	443.486084]
var shortSliderBounds = [387.486115, 446.486115]
var tallTubeBounds = [229.3759, 413.375885]
var shortTubeBounds = [231.375763,415.375748]
var sliderSelected = -1
var lockedPercent = 0
var sliderDistance = 59.999996
var upperLimit = 1
var mouseDifference = 0
var sliderLockedIndexes =[]
var sliderUnlockedCount = 4
var percentRunningSum = 0
var percentDifference
var percents = [0,0,0,0]
var tempPercent = 0
var subLimit = 0
var noMoveFlag = false
var tubeLabelInUse
var animalNamingFlag = false
var animPlayingFlag = false
var boxOpenFlag = false
func decrementOtherAnimals(event):
	#decrements other sliders
	for i in sliders.size():
		percents[i] = percentOfShare(i)
	print("Percents begin: ", percents)
	mouseDifference = sliders[sliderSelected].global_position.y-event.global_position.y
	percentDifference = mouseDifference/sliderDistance
	for i in sliderLockedIndexes:
		tempPercent += percents[i]
	tempPercent += percents[sliderSelected]
	tempPercent += percentDifference
	if tempPercent >= 1:
		tempPercent = 1
		noMoveFlag = true
	else:
		noMoveFlag == false

	subLimit = 1-tempPercent
	for i in sliders.size():
		if i == sliderSelected or i in sliderLockedIndexes:
			continue
		if noMoveFlag == false:
			sliders[i].global_position.y = convertToPos(i, subLimit/(sliderUnlockedCount-1))
			tubes[i].global_position.y = tubeConvertToPos(i, subLimit/(sliderUnlockedCount-1))
	tempPercent = 0
	subLimit = 0
	
func percentOfShare(x):
	if x == 0 or x == 3:
		return (tallSliderBounds[1] - sliders[x].global_position.y )/sliderDistance
	else:
		return (shortSliderBounds[1] - sliders[x].global_position.y )/sliderDistance

func convertToPos(x,percent):
	if x == 0 or x == 3:
		return tallSliderBounds[1]-(sliderDistance*percent)
	else:
		return shortSliderBounds[1]-(sliderDistance*percent)
func tubeConvertToPos(x,percent):
	if x == 0 or x == 3:
		return (tallTubeBounds[1]-(tubeSliderDist*percent))
	else:
		return (shortTubeBounds[1]-(tubeSliderDist*percent))
func resetMachine():
	resetButton.set_visible(false)
	sliderUnlockedCount = 4
	goButton.set_visible(false)
	sliderLockedIndexes.clear()
	upperLimit = 1
	resetReady = false
	for i in sliders.size():
		sliders[i].global_position.y = convertToPos(i, .25)
		tubes[i].global_position.y = tubeConvertToPos(i, .25)
		slidersLocked[i] = false
		lockers[i].set_visible(false)
func _input(event):
	if event is InputEventKey and event.scancode == KEY_ENTER and animalNamingFlag == true and event.pressed == true:
		emit_signal("nameEntered") #yields back to coroutine in Animals
	if event is InputEventKey and event.scancode == KEY_ESCAPE and animPlayingFlag == false and event.pressed == true:
		animalsNode.writeMoney()
		get_tree().change_scene("res://Lab.tscn")
	if event is InputEventMouseButton: 
		if event.pressed == true: # only activates on click not release
			if animalNamingFlag == false:
				for i in labelReady.size():
					if labelReady[i] == true and boxOpenFlag == false:
						boxOpenFlag = true
						displayDNANode.set_visible(true)
						tubeLabels[i].text = ""
						tubeLabelInUse = i
						get_node("../TotalMoneyLabel").set_visible(false)
						get_node("../CostLabel").set_visible(false)
						break
				for i in boxLabelReady.size():
					if boxLabelReady[i] == true:
						boxOpenFlag = false
						tubeLabels[tubeLabelInUse].text = boxLabels[i].text
						displayDNANode.set_visible(false)
						get_node("../TotalMoneyLabel").set_visible(true)
						get_node("../CostLabel").set_visible(true)
						tubeLabelInUse = -1
						animalsNode.updateCost()
						break
				if goReady == true and animalsNode.money > animalsNode.currCost:
					var tempGoDict = {}
					var tempGoArray = []
					for i in range(4):
						tempGoDict[percentOfShare(i)] = tubeLabels[i].text
						tempGoArray.append(percentOfShare(i))
					tempGoArray.sort()
					tempGoArray.invert()
					animalsNode.assembleAnimal(
						tempGoDict[tempGoArray[0]],
						tempGoDict[tempGoArray[1]],
						tempGoDict[tempGoArray[2]],
						tempGoDict[tempGoArray[3]])
					resetMachine()
					
				if resetReady == true: #RESETS EVERYTHING
					resetMachine()
				for i in lockersSelected.size(): #LOCKER SELECTION, this code could stand to be cleaned up
					if lockersSelected[i] == true:
						get_node("../SwitchSFX").play(0)
						if slidersLocked[i] == false:
							slidersLocked[i] = true
							sliderLockedIndexes.append(i)
							lockers[i].set_visible(true)
						else:
							slidersLocked[i] = false
							sliderLockedIndexes.erase(i)
							lockers[i].set_visible(false)
						if i == 1 or i == 2:
							lockedPercent += 1- (abs(shortSliderBounds[0]-sliders[i].global_position.y)/sliderDistance)
						else:
							lockedPercent += 1- (abs(tallSliderBounds[0]-sliders[i].global_position.y)/sliderDistance)
						upperLimit = 1 - lockedPercent
						sliderUnlockedCount = 4-sliderLockedIndexes.size()
				if sliderLockedIndexes.size() >= 3: # if last locker selected
					for i in sliders.size():
						if !(i in sliderLockedIndexes):
							sliderLockedIndexes.append(i)
							slidersLocked[i] = true
							lockers[i].set_visible(true)
					resetButton.set_visible(true)
					goButton.set_visible(true)
					get_node("../MachineInstructions").set_visible(false)
				if slidersBool[0] == true:
					sliderSelected = 0
				elif slidersBool[1] == true:
					sliderSelected = 1
				elif slidersBool[2] == true:
					sliderSelected = 2
				elif slidersBool[3] == true:
					sliderSelected = 3
			
		else: # if its releasing
				sliderSelected = -1
	elif event is InputEventMouseMotion and sliderSelected != -1 and slidersLocked[sliderSelected] == false:
		PCnode.play("idle1")
		if sliderSelected == 0:
			if event.global_position.y > tallSliderBounds[0] and event.global_position.y < 437.4860844 and (abs(tallSliderBounds[1]-event.global_position.y)/sliderDistance)  <= upperLimit :
				decrementOtherAnimals(event)
				if noMoveFlag == false:
					sliders[0].global_position.y = event.global_position.y
					tubes[0].global_position.y = ((event.global_position.y-tallSliderBounds[0])*3.06666662111)+tallTubeBounds[0]
		elif sliderSelected == 1:
			if event.global_position.y > shortSliderBounds[0] and event.global_position.y < 440.4861154 and abs(shortSliderBounds[1]-event.global_position.y)/sliderDistance <= upperLimit:
				decrementOtherAnimals(event)
				if noMoveFlag == false:
					sliders[1].global_position.y = event.global_position.y
					tubes[1].global_position.y = ((event.global_position.y-shortSliderBounds[0])*3.06666662111)+shortTubeBounds[0]
		elif sliderSelected == 2:
			if event.global_position.y > shortSliderBounds[0] and event.global_position.y < 440.4861154 and abs(shortSliderBounds[1]-event.global_position.y)/sliderDistance <= upperLimit:
				decrementOtherAnimals(event)
				if noMoveFlag == false:
					sliders[2].global_position.y = event.global_position.y
					tubes[2].global_position.y = ((event.global_position.y-shortSliderBounds[0])*3.06666662111)+shortTubeBounds[0]
		elif sliderSelected == 3:
			if event.global_position.y > tallSliderBounds[0] and event.global_position.y < 437.4860844 and abs(tallSliderBounds[1]-event.global_position.y)/sliderDistance <= upperLimit:
				decrementOtherAnimals(event)
				if noMoveFlag == false:
					sliders[3].global_position.y = event.global_position.y
					tubes[3].global_position.y = ((event.global_position.y-tallSliderBounds[0])*3.06666662111)+tallTubeBounds[0]
		lockedPercent = 0
		upperLimit = 1
		noMoveFlag = false
	elif animPlayingFlag == false:
		PCnode.play("idle2")
func _ready():
	#these are here because of weird bug
	sliders[0].global_position.y = 428.486085
	sliders[3].global_position.y = 428.486085
	
	connect("nameEntered",self,"onNameEntered")
	animalsNode.connect("nameEntered", self, "onNameEntered")
	
func onNameEntered():
	print("name entered on Machine")
func _process(delta):
	pass

func _on_Area2D_mouse_entered():
	slidersBool[0] = true

func _on_Area2D_mouse_exited():
	slidersBool[0] = false

func _on_Area2D2_mouse_entered():
	slidersBool[1] = true

func _on_Area2D2_mouse_exited():
	slidersBool[1] = false

func _on_Area2D3_mouse_entered():
	slidersBool[2] = true


func _on_Area2D3_mouse_exited():
	slidersBool[2] = false


func _on_Area2D4_mouse_entered():
	slidersBool[3] = true


func _on_Area2D4_mouse_exited():
	slidersBool[3 ] = false


func _on_LockerArea_mouse_entered():
	lockersSelected[0] = true


func _on_LockerArea_mouse_exited():
	lockersSelected[0] = false


func _on_LockerArea2_mouse_entered():
	lockersSelected[1] = true


func _on_LockerArea2_mouse_exited():
	lockersSelected[1] = false


func _on_LockerArea3_mouse_entered():
	lockersSelected[2] = true


func _on_LockerArea3_mouse_exited():
	lockersSelected[2] = false


func _on_LockerArea4_mouse_entered():
	lockersSelected[3] = true


func _on_LockerArea4_mouse_exited():
	lockersSelected[3] = false

func _on_ResetArea_mouse_entered():
	resetReady = true


func _on_ResetArea_mouse_exited():
	resetReady = false


func _on_GoArea_mouse_entered():
	goReady = true


func _on_GoArea_mouse_exited():
	goReady = false



func _on_LabelArea1_mouse_entered():
	labelReady[0] = true

func _on_LabelArea1_mouse_exited():
	labelReady[0] = false


func _on_LabelArea2_mouse_entered():
	labelReady[1] = true


func _on_LabelArea2_mouse_exited():
	labelReady[1] = false


func _on_LabelArea3_mouse_entered():
	labelReady[2] = true


func _on_LabelArea3_mouse_exited():
	labelReady[2] = false


func _on_LabelArea4_mouse_entered():
	labelReady[3] = true


func _on_LabelArea4_mouse_exited():
	labelReady[3] = false


func _on_DNArea1_mouse_entered():
	boxLabelReady[0] = true


func _on_DNArea1_mouse_exited():
	boxLabelReady[0] = false


func _on_DNArea2_mouse_entered():
	boxLabelReady[1] = true


func _on_DNArea2_mouse_exited():
	boxLabelReady[1] = false


func _on_DNArea3_mouse_entered():
	boxLabelReady[2] = true


func _on_DNArea3_mouse_exited():
	boxLabelReady[2] = false


func _on_DNArea4_mouse_entered():
	boxLabelReady[3] = true


func _on_DNArea4_mouse_exited():
	boxLabelReady[3] = false


func _on_DNArea5_mouse_entered():
	boxLabelReady[4] = true

func _on_DNArea5_mouse_exited():
	boxLabelReady[4] = false

func _on_DNArea6_mouse_entered():
	boxLabelReady[5] = true


func _on_DNArea6_mouse_exited():
	boxLabelReady[5] = false


func _on_DNArea7_mouse_entered():
	boxLabelReady[6] = true


func _on_DNArea7_mouse_exited():
	boxLabelReady[6] = false


func _on_DNArea8_mouse_entered():
	boxLabelReady[7] = true


func _on_DNArea8_mouse_exited():
	boxLabelReady[7] = false


func _on_DNArea9_mouse_entered():
	boxLabelReady[8] = true


func _on_DNArea9_mouse_exited():
	boxLabelReady[8] = false

func _on_DNArea10_mouse_entered():
	boxLabelReady[9] = true


func _on_DNArea10_mouse_exited():
	boxLabelReady[9] = false


func _on_DNArea11_mouse_entered():
	boxLabelReady[10] = true

func _on_DNArea11_mouse_exited():
	boxLabelReady[10] = false
	
func _on_DNArea12_mouse_entered():
	boxLabelReady[11] = true

func _on_DNArea12_mouse_exited():
	boxLabelReady[11] = false

func _on_DNArea13_mouse_entered():
	boxLabelReady[12] = true


func _on_DNArea13_mouse_exited():
	boxLabelReady[12] = false

