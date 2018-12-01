extends KinematicBody2D
var preferences = ["cute"]
var velocity = Vector2()
var haggleDifficulty = "very easy"
var target1 = Vector2(541.518188, 203.529999)
var target2 = Vector2(208.487595, 203.529999)
var target3 = Vector2(208.487595, 155.529999)
var hometarget = Vector2(541.518188, 114.636635)
onready var doorAnim = get_node("../FrontDoorAnimation")
onready var childAnim = get_node("ChildAnim")
onready var animalsNode = get_parent().get_node("../Animals2")
var movement1Done = false
var movement2Done = false
var movement3Done = false
var movement1ExitDone = false
var movement2ExitDone = false
var movement3ExitDone = false
var midpointExitDone = false
var introMovementBegin = false
signal done_entering
signal done_exiting
signal cycle_completed
var exitMovementActive = false
func _ready():
	connect("done_entering",self,"_on_done_entering")
	connect("done_exiting",self,"_on_done_exiting")
	#connect("cycle_completed",self,"_on_cycle_completed")
	
func enterBuilding():
	for x in animalsNode.shopPlacedSprites:
		x.set_visible(true)
	doorAnim.frame = 0
	doorAnim.play("opendoor")
	introMovementBegin = true
	self.set_visible(true)
	print("entering door")
	
func exitBuilding():
	for x in animalsNode.shopPlacedSprites:
		x.set_visible(true)
	doorAnim.frame = 0
	print("exiting building")
	get_parent().get_node("../PC").guestCounter += 1
	doorAnim.play("opendoor")
	self.set_visible(false)
	emit_signal("cycle_completed")
	movement1Done = false
	movement2Done = false
	movement3Done = false
	movement1ExitDone = false
	movement2ExitDone = false
	movement3ExitDone = false
	midpointExitDone = false
	self.position = hometarget
	print("cycle_completed")

func _on_cycle_completed():
	pass
func _on_done_exiting():
	pass
func _on_done_entering():
	get_parent().startHaggle()

func firstPoint():
	velocity = (target1 - self.position).normalized() * 100
    # rotation = velocity.angle()
	if (target1 - self.position).length() > 5:
		move_and_slide(velocity)
		childAnim.play("front")
	else:
		movement1Done = true

func secondPoint():
	velocity = (target2 - self.position).normalized() * 150
    # rotation = velocity.angle()
	if (target2 - self.position).length() > 5:
		move_and_slide(velocity)
		childAnim.flip_h = true
		childAnim.play("side")
	else:
		movement2Done = true

func thirdPoint():
	velocity = (target3 - self.position).normalized() * 150
    # rotation = velocity.angle()
	if (target3 - self.position).length() > 5:
		move_and_slide(velocity)
		childAnim.play("back")
	else:
		movement3ExitDone = true
		childAnim.play("idle")
		emit_signal("done_entering")
		introMovementBegin = false
	
func thirdPointExit():
	velocity = (target3 - self.position).normalized() * 150
    # rotation = velocity.angle()
	if (target3- self.position).length() > 5:
		move_and_slide(velocity)
		childAnim.play("front")
	else:
		movement3ExitDone = true

func secondPointExit():
	velocity = (target2 - self.position).normalized() * 150
    # rotation = velocity.angle()
	if (target2 - self.position).length() > 5:
		move_and_slide(velocity)
		childAnim.flip_h = false
		childAnim.play("side")
	else:
		movement2ExitDone = true
func midpointExit():
	velocity = (target1 - self.position).normalized() * 150
    # rotation = velocity.angle()
	if (target1 - self.position).length() > 5:
		move_and_slide(velocity)
		childAnim.flip_h = false
		childAnim.play("side")
	else:
		midpointExitDone = true

func firstPointExit():
	velocity = (hometarget - self.position).normalized() * 100
    # rotation = velocity.angle()
	if (hometarget - self.position).length() > 5:
		move_and_slide(velocity)
		childAnim.play("back")
	else:
		movement1ExitDone = true
		print("exiting door")
		exitBuilding()
		emit_signal("done_exiting")
		exitMovementActive = false
	

func _process(delta):
	if introMovementBegin == true:
		if movement1Done == false:
			firstPoint()
		elif movement2Done == false:
			secondPoint()
		elif movement3Done == false:
			thirdPoint()
	elif exitMovementActive == true:
		if movement3ExitDone == false:
			thirdPointExit()
		elif movement2ExitDone == false:
			secondPointExit()
		elif midpointExitDone == false:
			midpointExit()
		elif movement1ExitDone == false:
			firstPointExit()

func _on_DialogueParser_dialogue_ended():
	pass
	#enterBuilding()#change to different signal before release
