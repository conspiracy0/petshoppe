extends Sprite
var isFalling = false
var posCounter = 0
var DC1points = {
	"left": Vector2(100.640015,328.882233),
	"left2": Vector2(100.640015,377.882233), 
	"right2": Vector2(157.640015,377.882233),
	"right": Vector2(157.640015,328.88223)
	}
var DC2points = {
	"left": Vector2(294.117371,125.179276),
	"middle": Vector2(354.117371,125.179276),
	"right": Vector2(415.117371,125.179276)
	}
var DC3points = {
	"left": Vector2(293.388672, 333.206146),
	"left2": Vector2(293.388672, 381.206146),
	"middlebot": Vector2(354.388672,381.206146),
	"right2": Vector2(415.388672,381.206146),
	"right": Vector2(415.388672,332.206146),
	"middletop": Vector2(354.388672,332.206146)
	}
var DC4points = {"solo": Vector2(611.624634,128.575821)}
var DC5points = {
	"top": Vector2(611.624634, 330.575806),
	"bottom": Vector2(611.624634,379.575806)
	}
var usedPoints = []
onready var PCbody = get_node("../PC")
onready var ArrowArea = get_node("Area2D")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	#hover code
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

	if ArrowArea.overlaps_body(PCbody) and !(self.position in usedPoints):
		self.set_visible(true)
		if PCbody.canInteract == false and PCbody.inList == false: # prevents it from reassigning every frame and wasting resources
			PCbody.canInteract = true
	else:
		self.set_visible(false)
		if PCbody.canInteract == true: # prevents it from reassigning every frame and wasting resources
			PCbody.canInteract = false

func changeLocation(dc, newpt):
	if dc == 1:
		if !(DC1points[newpt] in usedPoints):
			self.position = DC1points[newpt]
	if dc == 2:
		if !(DC2points[newpt] in usedPoints):
			self.position = DC2points[newpt]
	if dc == 3:
		if !(DC3points[newpt] in usedPoints):
			self.position = DC3points[newpt]
	if dc == 4:
		if !(DC4points[newpt] in usedPoints):
			self.position = DC4points[newpt]
	if dc == 5:
		if !(DC5points[newpt] in usedPoints):
			self.position = DC5points[newpt]