extends KinematicBody2D
var preferences = ["cute"]
var velocity = Vector2()
var haggleDifficulty = "very easy"
var target1 = Vector2(541.518188, 203.529999)
var target2 = Vector2(208.487595, 203.529999)
var target3 = Vector2(208.487595, 155.529999)
var hometarget = Vector2(541.518188, 114.636635)
onready var doorAnim = get_node("../FrontDoorAnimation")
var movement1Done = false
var movement2Done = false
var movement3Done = false
var introMovementBegin = false

func _ready():
	pass 

func enterBuilding():
	doorAnim.play("opendoor")
	introMovementBegin = true
	self.set_visible(true)

func firstPoint():
	velocity = (target1 - self.position).normalized() * 100
    # rotation = velocity.angle()
	if (target1 - self.position).length() > 5:
		move_and_slide(velocity)
	else:
		movement1Done = true

func secondPoint():
	velocity = (target2 - self.position).normalized() * 150
    # rotation = velocity.angle()
	if (target2 - self.position).length() > 5:
		move_and_slide(velocity)
	else:
		movement2Done = true

func thirdPoint():
	velocity = (target3 - self.position).normalized() * 150
    # rotation = velocity.angle()
	if (target3 - self.position).length() > 5:
		move_and_slide(velocity)
	else:
		movement3Done = true
		
func _process(delta):
	if introMovementBegin == true:
		if movement1Done == false:
			firstPoint()
		elif movement2Done == false:
			secondPoint()
		elif movement3Done == false:
			thirdPoint()

func _on_DialogueParser_dialogue_ended():
	pass
	#enterBuilding()#change to different signal before release
