extends RigidBody3D

@export var move_speed : int = 50
@export var turn_speed : int = 1
@export var visibility : int = 50
@export var attention_span : int = 5000
var cooldown = false
var timer

#Create sonar pulse
func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", _timeout)

func _physics_process(delta):
	var input_direction = Vector3(
		0,
		0,
		Input.get_action_strength("Back") - Input.get_action_strength("Forward")
	)
	
	if(Input.is_action_pressed("Up")):
		transform.basis = Basis(transform.basis.x, deg_to_rad(turn_speed)) * transform.basis
	if(Input.is_action_pressed("Down")):
		transform.basis = Basis(transform.basis.x, deg_to_rad(-turn_speed)) * transform.basis
	if(Input.is_action_pressed("Right")):
		transform.basis = Basis(transform.basis.y, deg_to_rad(-turn_speed)) * transform.basis
	if(Input.is_action_pressed("Left")):
		transform.basis = Basis(transform.basis.y, deg_to_rad(turn_speed)) * transform.basis
	if(Input.is_action_pressed("Boost")):
		apply_force(basis * input_direction * move_speed * 50)
	else:
		apply_force(basis * input_direction * move_speed)
		
	#Raycast look for Objects
	if(Input.is_action_pressed("Ping") && cooldown == false):
		var object_hit
		var space_state = get_world_3d().direct_space_state
		for i in attention_span:
			var query = PhysicsRayQueryParameters3D.create(global_position, global_position + Vector3(randi_range(-1,1), randi_range(-1,1), randi_range(-1,1)).normalized() * visibility)
			query.collide_with_bodies == true
			var result = space_state.intersect_ray(query)
			print(result)
			if (result.size() > 0):
				object_hit = result.keys()
				print(object_hit)
				timer.start(5)
				cooldown = true
				break
	
func _timeout():
	cooldown = false
