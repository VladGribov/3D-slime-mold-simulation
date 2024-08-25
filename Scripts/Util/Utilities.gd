extends Node

#Get properties of class and assign them to a new object of the same type
func copyOf(object : Object) -> Object:
	var data = object
	var properties = data.get_property_list()
	var copyOfData = data.duplicate()
	for i in range(properties.size()):
		if(properties[i].usage == 4096 || properties[i].usage == 135168):
			copyOfData.set(properties[i].name, data.get(properties[i].name))
	return copyOfData
