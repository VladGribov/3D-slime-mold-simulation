extends MeshInstance3D

@export var lifetime : int = 15
var timer
var count = 0
var color_drain

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", _timeout)
	timer.start(lifetime)
	color_drain = get_surface_override_material(0).albedo_color / lifetime

func _physics_process(delta):
	if(count >= 1):
		print(get_surface_override_material(0).albedo_color)
		get_surface_override_material(0).albedo_color -= color_drain
		count = 0
	else:
		count += delta

func _timeout():
	queue_free()
