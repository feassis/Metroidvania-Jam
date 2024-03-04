# Dynamic Map Loader
# 1. Input *.tmx file
# 2. Uses YATI version 1.6.6 to parse file. Include addons & runtime from YATI.
# 3. Parse 0 Vert >> Object Data Object Layer (there are saved spawner locations)

extends Node

const MyMapMetaJson = preload("res://Code/Map/MyMapMetaJson.gd").MyMapMetaJson

const MAPS_FOLDER: String = "res://Maps/"
const STARTING_MAP_FILE: int = 0
const MAPS_META_DATA: String = "res://Maps/map_metadata.json"

#Scene elements
const DW_TAG_FOREGORUND: String = "1 Foreground"
const DW_TAG_GAME: String = "2 GameElements"
const DW_TAG_BACKGROUND: String = "3 Background"
const DW_TAG_STATIC: String = "Static"
const DW_TAG_DYNAMIC: String = "Dynamic"

#*.TMX names
const TMX_TAG_VERTICES: String = "0 Vert"
const TMX_TAG_DATA: String = "Object data" #Sensors, spawners, iter objects,.. ... require post processing
const TMX_TAG_STATIC: String = "Static" #Static collission objects
const TMX_TAG_FOREGROUND: String = "1 Background Layers"
const TMX_TAG_BACKGROUND: String = "2 Foreground Layers"

var YATI_loader = null #call preload 1 time only ... at start
var meta_data: MyMapMetaJson = null

func _ready():
	parse_meta_data(MAPS_META_DATA)
	
	YATI_loader = preload("res://runtime/Importer.gd").new() #init 1 time only
	load_tmx_by_id(STARTING_MAP_FILE) #Staring map file
	
func parse_meta_data(path: String):
	var text = FileAccess.get_file_as_string(path)
	var json = JSON.parse_string(text)
	
	meta_data = MyMapMetaJson.new(json)

#Load new tmx map file into same scene
func load_tmx(path: String):
	if Globals.debug:
		print("[sys] ... DynamicLoader ... starts loading ... " + path)
		
	#1. Init
	var node_fg = get_node(DW_TAG_FOREGORUND)
	var node_ge = get_node(DW_TAG_GAME)
	var node_bg = get_node(DW_TAG_BACKGROUND)
	var node_static = get_node(DW_TAG_STATIC)
	var node_dynamic = get_node(DW_TAG_DYNAMIC)
	
	#2. Clean
	empty_node(node_fg)
	empty_node(node_ge)
	empty_node(node_bg)
	empty_node(node_static)
	empty_node(node_dynamic)
	
	#3. Process
	var new_map_node = YATI_loader.import(path) #.get_child(0) #Core has only 1 child. R0000
	
	var new_bg_layer = find_node(new_map_node, TMX_TAG_BACKGROUND)
	var new_fg_layer = find_node(new_map_node, TMX_TAG_FOREGROUND)
	
	var vert = find_node(new_map_node, TMX_TAG_VERTICES)
	var new_static = find_node(vert, TMX_TAG_STATIC)
	var new_dynamic = find_node(vert, TMX_TAG_DATA) #to process
	
	node_fg.add_child(new_fg_layer)
	node_bg.add_child(new_bg_layer)
	node_static.add_child(new_static)
	
	#get_tree().current_scene.add_child(new_map_node.duplicate()) #YATI only ... no processing

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#TODO: remove after all works. Used for test purposes
func _input(event):
	if not(event is InputEventKey and event.is_released()):
		return #nov valid event
	
	if event.keycode == KEY_T:
		load_tmx_by_id(1) #Staring map file

func load_tmx_by_id(id: int):
	var path = MAPS_FOLDER + meta_data.rooms[id].file
	load_tmx(path)
	
#Get spawn location on world based on map spawners data
func spawn_location(): #TODO 
	
	#var spawners = get_spawners()
	#var spawner = spawners.at
	
	var x = 0
	var y = 0
	
	return Vector2(x, y)
	
func find_node(node: Node2D, target: String):
	var N = node.get_child_count()

	for i in range(N):
		var child = node.get_child(i)
		if child.name == target:
			node.remove_child(child) #2 or more Node2D in Godot cannot have same child
			return child

	return null
	
func empty_node(node: Node2D):
	var N = node.get_child_count()
	
	for i in range(N):
		var child = node.get_child(i)
		node.remove_child(child)
		child.call_deferred("free")
	
	if Globals.debug && N > 0:
		print("[sys] ... clear")
