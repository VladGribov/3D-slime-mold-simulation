extends Node3D


func _ready():
	for i in 3000: 
		var Li = preload("res://Scenes/Li.tscn").instantiate()
		Li.position = Vector3(randi_range(-1000,1000), randi_range(-1000,1000), randi_range(-1000,1000))
		Li.transform.basis = Li.transform.basis.rotated(Vector3(1,0,0), deg_to_rad(randi_range(-180,180)))
		Li.transform.basis = Li.transform.basis.rotated(Vector3(0,1,0), deg_to_rad(randi_range(-180,180)))
		add_child(Li)
		
	for i in 0:
		var randx1 = randi_range(-1000, 0)
		var randx2 = randi_range(0, 1000)
		var randfinalx1 = randi_range(randx1,randx2)
		var randx3 = randi_range(-1000, 0)
		var randx4 = randi_range(0, 1000)
		var randfinalx2 = randi_range(randx3,randx4)
		var randfinalx = randi_range(randfinalx1, randfinalx2)
		
		var randy1 = randi_range(-1000, 0)
		var randy2 = randi_range(0, 1000)
		var randfinaly1 = randi_range(randy1,randy2)
		var randy3 = randi_range(-1000, 0)
		var randy4 = randi_range(0, 1000)
		var randfinaly2 = randi_range(randy3,randy4)
		var randfinaly = randi_range(randfinaly1, randfinaly2)
		
		var randz1 = randi_range(-1000, 0)
		var randz2 = randi_range(0, 1000)
		var randfinalz1 = randi_range(randz1,randz2)
		var randz3 = randi_range(-1000, 0)
		var randz4 = randi_range(0, 1000)
		var randfinalz2 = randi_range(randz3,randz4)
		var randfinalz = randi_range(randfinalz1, randfinalz2)
		
		var Mu = preload("res://Scenes/Mu.tscn").instantiate()
		Mu.position = Vector3(randfinalx, randfinaly, randfinalz)
		add_child(Mu)
