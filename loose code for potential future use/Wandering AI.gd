extends KinematicBody2D
var canMove = true
var preferences = ["cute"]
var totalStay
var walkTimer
var speed = 2
var lastDirection
var move_direction = Vector2(0,0)
onready var doorAnim = get_node("../FrontDoorAnimation")
var randomSelect
var movementLength

func _ready():
	movementLength = Timer.new()
	movementLength.set_one_shot(true)
	movementLength.set_wait_time(1.5)
	self.add_child(movementLength)
	movementLength.connect("timeout",self,"on_move_timeout")
	
	enterBuilding() #change this layout later 
	pass
func _process(delta):
	move_and_collide(move_direction.normalized() * speed)

func checkforAnimal():
	pass

func enterBuilding():
	doorAnim.play("opendoor")
	self.set_visible(true)
	#if preferences not found after CheckAnimal
	wander()

func wander():
	totalStay = Timer.new()
	totalStay.set_one_shot(true)
	totalStay.set_wait_time(140) #2.4 or so minutes
	self.add_child(totalStay)
	totalStay.connect("timeout",self,"on_stay_timeout")
	totalStay.start()
	walkTimer = Timer.new()
	walkTimer.set_one_shot(false)
	walkTimer.set_wait_time(2) #default value
	self.add_child(walkTimer)
	walkTimer.connect("timeout",self,"on_walk_timeout")
	walkTimer.start()
	
	
func on_walk_timeout():
	print("walktimerdone")
	walkTimer.set_wait_time(2 + (randi()%4))
	randomSelect = randi()%4 # for movement direction
	if randomSelect == 0:
		move_direction = Vector2(1,0)
	elif randomSelect == 1:
		move_direction = Vector2(-1,0)
	elif randomSelect == 2:
		move_direction = Vector2(0,1)
	else:
		move_direction = Vector2(0,-1)
	movementLength.start()
	print("moving")
	print(move_direction)

func on_move_timeout():
	move_and_collide(Vector2(0,0) * 0)
	move_direction = Vector2(0,0)
	print("moving done")

func on_stay_timeout():
	pass #exit building and queue_free timer