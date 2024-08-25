extends RigidBody3D

enum STATE{WANDER, IDLE, APPROACH, FOLLOW}
var maxHealth : float = 100.0
var maxHunger : float = 100.0
var speed : float = 100.0
var visionRange : float = 100.0
var currentHealth : float = maxHealth
var currentHunger : float = maxHunger #Prey drive increases based on hunger
var currentState = STATE.IDLE
var timer
var timeout : bool = true

#Create "imprints of self" text or image creations
#Ask for help
#Ask for advice

func _init():
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", _timeout)
	
func _physics_process(delta):
	if(randi_range(0,100) <= 2):
		currentHunger -=1
		if(currentHealth <= 0 || currentHunger <= 0):
			#die()
			pass
	update(delta)

func update(delta):
	if(randi_range(0,100000) ==0 && currentState == STATE.IDLE && linear_velocity == Vector3.ZERO && delta && timeout == true):
		currentState = STATE.WANDER
		timer.start(randi_range(5,15))
		apply_impulse(chooseLocation())
		timeout = false

func chooseLocation():
	var length = randi_range(-100,100)
	var randomDirection = Vector3(randi_range(-100,100),randi_range(-100,100),randi_range(-100,100)).normalized() * length
	return randomDirection
	
func die():
	queue_free()

func _timeout():
	currentState == STATE.IDLE
	timeout = true
