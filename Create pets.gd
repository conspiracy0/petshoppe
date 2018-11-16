extends Sprite

var containerSize = [78,366] #pixels, full box is 80x371 pixels wide
var colorBox1
var colorBox2
var colorBox3
var colorBox4
var containerBox
var colorRatio1
var colorRatio2
var colorRatio3
var colorRatio4

#center position of main box is 871, 265

func _ready():
	containerBox = get_node("../Ratio Mix")
	colorBox1 = containerBox.get_node("ColorRect")
	colorBox2 = containerBox.get_node("ColorRect2")
	colorBox3 = containerBox.get_node("ColorRect3")
	colorBox4 = containerBox.get_node("ColorRect4")
	#initialize the signals to other boxes
	#eventually use a texture for the ratios
	adjustRatios4var()
	
func setDefaultRatiosDisplay4var():
	#positions are set by the TOP of the box, and size y comes out from there
	#default size is 78 pixels wide
	colorBox1.set_position(Vector2(-39,-183))
	colorBox2.set_position(Vector2(-39, -91.5))
	colorBox3.set_position(Vector2(-39, 0))
	colorBox4.set_position(Vector2(-39,91.5))
	colorBox1.set_size(Vector2(78,91.5))
	colorBox2.set_size(Vector2(78,91.5))
	colorBox3.set_size(Vector2(78,91.5))
	colorBox4.set_size(Vector2(78,91.5))

func adjustRatios4var():
	#get percentages from sliders
	# for now just uses test values
	var ratio1 = .5
	var ratio2 = .13
	var ratio3 = .17
	var ratio4 = .20
	
	"""Step 1: Calculate the absolute y amounts from 0-366 that the colors will take up accordiongly
	Step 2: Calculate the offset 
		First, the top of the bar is -183
			Set colorBox1's size y value to share1
		Next, the second ratio:
			Set Colorbox2's Y position to -183+share1
			Set colorbox2's Y size to share2
		Next, the third ratio:
			Set colorbox3's Y position to -183+share1+share2
			Set colorbox3's Y size to share3
		Finally, 
			Set colorbox4's Y position to -183+share1+share2+share3
			Set colorbox4's Y size to share4
	"""
	var share1 = ratio1*containerSize[1]
	var share2 = ratio2*containerSize[1]
	var share3 = ratio3*containerSize[1]
	var share4 = ratio4*containerSize[1]
	colorBox1.set_position(Vector2(-39,-183))
	colorBox1.set_size(Vector2(78, share1))
	colorBox2.set_position(Vector2(-39,-183+share1))
	colorBox2.set_size(Vector2(78, share2))
	colorBox3.set_position(Vector2(-39,-183+share1+share2))
	colorBox3.set_size(Vector2(78, share3))
	colorBox4.set_position(Vector2(-39,-183+share1+share2+share3))
	colorBox4.set_size(Vector2(78,share4))
	
	
func displayRatios():
	pass
	# colorBox1.get_size()[1] y value
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
