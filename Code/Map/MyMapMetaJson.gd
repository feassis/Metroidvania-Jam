class MyMapMetaJson:
	var iter_objects_data: Array[IterObjectJson] = []
	var types: Array[TypeJson] = []
	var rooms: Array[RoomJson] = []
	var area_data: Array[AreaJson] = []

	func _init(data: Dictionary):
		var A = data["iter objects data"]
		for a in A:
			if a.has("teleportCD"):
				iter_objects_data.append(TeleportIterObjectJson.new(a))
			else:
				iter_objects_data.append(IterObjectJson.new(a))
		
		var B = data["types"]
		for b in B:
			types.append(TypeJson.new(b))
		
		var C = data["rooms"]
		for c in C:
			rooms.append(RoomJson.new(c))
			
		var D = data["area data"]
		for d in D:
			types.append(AreaJson.new(d))

class TypeJson:
	var id: int
	var name: String
	
	func _init(data: Dictionary):
		id = data["id"]
		name = data["name"]
		
class IterObjectJson:
	var id: int
	var name: String
	var description: String
	var type: int #link id to types
	
	func _init(data: Dictionary):
		id = data["id"]
		name = data["name"]
		description = data["description"]
		type = data["type"]
	
class TeleportIterObjectJson extends IterObjectJson:
	var teleportCD: int
	
	func _init(data: Dictionary):
		super(data)
		teleportCD = data["teleportCD"]
	
class RoomJson:
	var id: int
	var name: String
	var description: String
	var file: String
	var sound_track: String
	
	func _init(data: Dictionary):
		id = data["id"]
		name = data["name"]
		description = data["description"]
		file = data["file"]
		sound_track = data["sound track"]
	
class AreaJson:
	var id: int
	var name: String
	var description: String
	
	func _init(data: Dictionary):
		id = data["id"]
		name = data["name"]
		description = data["description"]
