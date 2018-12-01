extends Label


var clickEnabled = false
func _ready():
	var f1 = File.new()
	f1.open("res://animal containers/createdanimals.json", File.READ)
	var f2 = File.new()
	var temp = f1.get_as_text()
	f2.open("user://createdanimals.json", File.WRITE)
	f2.store_string(temp)
	f1.open("res://dialogue/money.txt", File.READ)
	f2.open("user://money.txt",File.WRITE)
	f2.store_string(f1.get_as_text())
	f1.open("res://dialogue/dayFlag.txt",File.READ)
	f2.open("user://dayFlag.txt",File.WRITE)
	f2.store_string(f1.get_as_text())

func _input(event):
	if event is InputEventMouseButton and event.pressed == true and clickEnabled == true:
		get_tree().change_scene("res://Lab.tscn")
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Area2D_mouse_entered():
	clickEnabled = true


func _on_Area2D_mouse_exited():
	clickEnabled = false
