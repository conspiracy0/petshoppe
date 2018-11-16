extends KinematicBody2D

var canMove = true
var canInteract = false
var speed = 2 
var lastDirection
var move_direction = Vector2(0,0)

onready var PCsprite = get_node("AnimatedSprite")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	if(canMove):
		move_player()
	
	
func move_player():
	move_direction = Vector2(0,0)
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