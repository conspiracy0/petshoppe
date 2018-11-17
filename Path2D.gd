extends Path2D
var velocity = 3
var curvepath
var points = [Vector2(541.518188, 114.636635),Vector2(541.518188, 203.529999),Vector2(208.487595, 203.529999)]
func _ready():
	curvepath = Curve2D.new()
	curvepath.add_point(points[0])
	curvepath.add_point(points[1])
	curvepath.add_point(points[2])

#func _process(delta):
