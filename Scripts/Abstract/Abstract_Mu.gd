extends Node
class_name AbstractMu

var maxHealth : float = 100.0
var maxHunger : float = 100.0
var speed : float = 100.0
var visionRange : float = 100.0
var currentHealth : float = maxHealth
var currentHunger : float = maxHunger #Prey drive increases based on hunger

func _physics_process(delta):
	if(randi_range(0,100) <= 2):
		currentHunger -=1
		if(currentHealth <= 0 || currentHunger <= 0):
			die()

func die():
	queue_free()
