extends Area3D

@export var max_distance_from_center = 1000
@export var turn_speed = 40
var count = 0
var movement
var movement_speed = 10 * -1 #-1 Because forward movement is in the -z direction
var direction_average : Vector3 = Vector3.ONE
var timer
var location_array = []
var look_direction = Vector3.ZERO
@onready var sphere_mesh = SphereMesh.new()
@onready var sphere_shape = SphereShape3D.new()
@onready var surface_material = load("res://Resources/Nu_Material.tres")
var pheromone_area_instance
var pheromone_mesh_instance
@onready var rs = LiManager.rs
@onready var ps = LiManager.ps
@export var pheromone_max_size = 3
var pheromone_dict = {}
var pheromone_count = 0
var replace = false
var spawn_count = 0
var pheromone_spawn_count = 0
var pheromone_spawn = 0

func _ready():
	if(spawn_count < LiManager.spawn_batches):
		LiManager.object_dictionary[self] = spawn_count
		spawn_count += 1
	else:
		spawn_count = 0
		LiManager.object_dictionary[self] = spawn_count
		spawn_count += 1
		
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", _timeout)
	timer.start(randf_range(1.0,3.0))

func _physics_process(delta):
	#forward movement along the z basis
	movement = transform.basis.z * movement_speed
	if(count >= 3):
		initialize_pheromone(rs,ps)
		count = 0
	else:
		count += delta
		if(location_array.size() != 0):
			for element in location_array:
				look_direction += element
			look_direction = look_direction / location_array.size()
			
			#slerp to the look direction
			var direction_to_target = (look_direction - global_position).normalized()
			transform.basis = transform.basis.slerp(transform.basis.looking_at(direction_to_target), turn_speed * delta)
			
			
			look_direction = Vector3.ZERO
			location_array.clear()
	
	if(global_position.length() >= max_distance_from_center):
		look_at(Vector3.ZERO)
	position += movement * delta

func initialize_pheromone(rs: RenderingServer, ps: PhysicsServer3D):
	if(pheromone_spawn <= pheromone_max_size):
		pheromone_area_instance = ps.area_create()
		pheromone_mesh_instance = rs.instance_create()
		#Physics server create Area and set parameters
		ps.area_set_space(pheromone_area_instance, get_world_3d().space)
		ps.area_add_shape(pheromone_area_instance, sphere_shape, Transform3D(Basis(), Vector3.ZERO))
		ps.area_set_collision_layer(pheromone_area_instance, 2)
		ps.area_set_monitorable(pheromone_area_instance, true)
		ps.area_set_transform(pheromone_area_instance, Transform3D(Basis(), global_position))
		#Rendering server create mesh and set parameters
		rs.instance_set_base(pheromone_mesh_instance, sphere_mesh)
		rs.instance_set_scenario(pheromone_mesh_instance, get_world_3d().scenario)
		rs.instance_set_transform(pheromone_mesh_instance, Transform3D(Basis(), global_position))
		rs.instance_set_surface_override_material(pheromone_mesh_instance, 0, surface_material)
		
		
		if(pheromone_spawn_count < LiManager.pheromone_spawn_batches):
			LiManager.pheromone_object_dictionary[self] = pheromone_spawn_count
			pheromone_spawn_count += 1
		else:
			pheromone_spawn_count = 0
			LiManager.pheromone_object_dictionary[self] = pheromone_spawn_count
			pheromone_spawn_count += 1
		
		
		pheromone_spawn += 1
		
	#Saving, ordering, and clearing excess pheromones
	if(pheromone_count <= pheromone_max_size && !replace):
		pheromone_dict[pheromone_count] = [pheromone_area_instance, pheromone_mesh_instance]
		pheromone_count += 1
	else:
		if(replace == false):
			pheromone_count = 0
		replace = true
		
		#Setting instances of area and mesh to position of Li in order to forgo constant creation and deletion of objects
		if(pheromone_count <= pheromone_max_size):
			#instead of delete, move to front
			ps.area_set_transform(pheromone_dict[pheromone_count][0], Transform3D(Basis(), global_position))
			rs.instance_set_transform(pheromone_dict[pheromone_count][1], Transform3D(Basis(), global_position))
			pheromone_count += 1
			if(pheromone_count > pheromone_max_size):
				pheromone_count = 0
	
func randomDirection():
	#transform.basis = lerp(transform.basis, transform.basis.rotated(Vector3(1,0,0), deg_to_rad(randi_range(-45,45))), 0.2)
	#transform.basis = lerp(transform.basis, transform.basis.rotated(Vector3(0,1,0), deg_to_rad(randi_range(-45,45))), 0.2)
	
	transform.basis = transform.basis.slerp(transform.basis.rotated(Vector3(1,0,0), deg_to_rad(randi_range(-45,45))), 0.5)
	transform.basis = transform.basis.slerp(transform.basis.rotated(Vector3(0,1,0), deg_to_rad(randi_range(-45,45))), 0.5)

#Detecting Created Areas
func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if(area_rid != null):
		location_array.append(ps.area_get_transform(area_rid).origin)

func _timeout():
	randomDirection()
	timer.start(randf_range(1.0,3.0))
