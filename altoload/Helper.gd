extends Node


func add_to_world(node : Node):
	print('yo')
	get_tree().root.get_node('World').add_child(node)
