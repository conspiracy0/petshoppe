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
var slidersBool = [
	false, #1
	false, #2
	false, #3
	false, #4
	]
var slidersLocked = [ false, true, false, false]
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
var sliderUnlockedCount
var percentRunningSum = 0
func decrementOtherAnimals(event):
	#decrements other sliders
	mouseDifference = sliders[sliderSelected].global_position.y-event.global_position.y
	for i in sliders.size():
		if !(i in sliderLockedIndexes):
			percentRunningSum += percentOfShare(i) #adds each percentage of current share to runningSum
	#print(percentRunningSum)
	#print("POS ",percentOfShare(sliderSelected))
	#print("UL ",upperLimit)
	percentRunningSum = 0 #reset
		
func percentOfShare(x):
	return abs(sliders[x].global_position.y -tallSliderBounds[1])/sliderDistance
func _input(event):
   # Mouse in viewport coordinates
	if event is InputEventMouseButton: # only activates on click not release
		#print("Mouse Click/Unclick at: ", event.position)
		if event.pressed == true:
			if slidersBool[0] == true:
				sliderSelected = 0
			if slidersBool[1] == true:
				sliderSelected = 1
			if slidersBool[2] == true:
				sliderSelected = 2
			if slidersBool[3] == true:
				sliderSelected = 3
		else: # if its releasing
			sliderSelected = -1
	elif event is InputEventMouseMotion and sliderSelected != -1 and slidersLocked[sliderSelected] == false:
		for i in slidersLocked.size():
			if slidersLocked[i] == true and !(i in sliderLockedIndexes)  :
				sliderLockedIndexes.append(i)
				sliderUnlockedCount = 4-sliderLockedIndexes.size()
				if i == 1 or i == 2:
					lockedPercent += 1- (abs(shortSliderBounds[0]-sliders[i].global_position.y)/sliderDistance)
				else:
					lockedPercent += 1- (abs(tallSliderBounds[0]-sliders[i].global_position.y)/sliderDistance)
					
				upperLimit = 1 - lockedPercent
			
		if sliderSelected == 0:
			if event.global_position.y > tallSliderBounds[0] and event.global_position.y < tallSliderBounds[1] and ((abs(tallSliderBounds[1]-event.global_position.y)/sliderDistance)  <= upperLimit) :
				
				decrementOtherAnimals(event)
				sliders[0].global_position.y = event.global_position.y
				print("tesT ", abs(tallSliderBounds[1]-event.global_position.y)/sliderDistance)
				print("POS ", percentOfShare(0))
				tubes[0].global_position.y = ((event.global_position.y-tallSliderBounds[0])*3.06666662111)+tallTubeBounds[0]
				
		elif sliderSelected == 1:
			if event.global_position.y > shortSliderBounds[0] and event.global_position.y < shortSliderBounds[1]and 1 - abs(shortSliderBounds[0]-event.global_position.y)/sliderDistance <= upperLimit:
				decrementOtherAnimals(event)
				sliders[1].global_position.y = event.global_position.y
				tubes[1].global_position.y = ((event.global_position.y-shortSliderBounds[0])*3.06666662111)+shortTubeBounds[0]
		elif sliderSelected == 2:
			if event.global_position.y > shortSliderBounds[0] and event.global_position.y < shortSliderBounds[1]and 1 - abs(shortSliderBounds[0]-event.global_position.y)/sliderDistance <= upperLimit:
				decrementOtherAnimals(event)
				sliders[2].global_position.y = event.global_position.y
				tubes[2].global_position.y = ((event.global_position.y-shortSliderBounds[0])*3.06666662111)+shortTubeBounds[0]
		elif sliderSelected == 3:
			if event.global_position.y > tallSliderBounds[0] and event.global_position.y < tallSliderBounds[1]and 1 - abs(tallSliderBounds[0]-event.global_position.y)/sliderDistance <= upperLimit:
				decrementOtherAnimals(event)
				sliders[3].global_position.y = event.global_position.y
				tubes[3].global_position.y = ((event.global_position.y-tallSliderBounds[0])*3.06666662111)+tallTubeBounds[0]
		lockedPercent = 0
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

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
