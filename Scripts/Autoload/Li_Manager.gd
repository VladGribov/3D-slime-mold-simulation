extends Node

@onready var rs = RenderingServer
@onready var ps = PhysicsServer3D
#Li
@onready var object_dictionary = {}
#Base 60
@export var spawn_batches = 60
var current_batch = 0

#Pheromone
@onready var pheromone_object_dictionary = {}
#base 60
@export var pheromone_spawn_batches = 60
var current_pheromone_batch = 0

func _physics_process(delta):
#Add and remove collision mask for each Li
	for object in object_dictionary:
		if(object_dictionary[object] == current_batch):
			object.set_collision_mask_value(2, true)
		else:
			object.set_collision_mask_value(2, false)
	current_batch += 1
	if(current_batch > spawn_batches):
		current_batch = 0
		
#Add and remove each collision layer for each pheromone
	for pheromone_object in pheromone_object_dictionary:
		if(pheromone_object_dictionary[pheromone_object] == current_pheromone_batch):
			ps.area_set_shape_disabled(pheromone_object, 0, false)
		else:
			ps.area_set_shape_disabled(pheromone_object, 0, true)
	current_pheromone_batch += 1
	if(current_pheromone_batch > pheromone_spawn_batches):
		current_pheromone_batch = 0
