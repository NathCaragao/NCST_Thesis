# CutsceneManager.gd
extends Node

# Dictionary to store the cutscene instances
var cutscene_instances = {}

# Reference to the CanvasLayer node where the cutscenes will be added
var canvas_layer: CanvasLayer = null

# Function to set the CanvasLayer node
func set_canvas_layer(canvas_layer_node: CanvasLayer):
	canvas_layer = canvas_layer_node

# Function to add a cutscene
func add_cutscene(cutscene_path, cutscene_name):
	var cutscene = load(cutscene_path).instantiate()
	cutscene_instances[cutscene_name] = cutscene
	if canvas_layer:
		canvas_layer.add_child(cutscene)


# Function to play a specific cutscene
func play_cutscene(cutscene_name):
	if cutscene_name in cutscene_instances:
		cutscene_instances[cutscene_name].play()
		print("cutscene playing: ", cutscene_name)

# Function to stop a specific cutscene
func stop_cutscene(cutscene_name):
	if cutscene_name in cutscene_instances:
		cutscene_instances[cutscene_name].close()

# Function to clear all cutscenes
func clear_cutscenes():
	for cutscene_name in cutscene_instances:
		if canvas_layer:
			canvas_layer.remove_child(cutscene_instances[cutscene_name])
	cutscene_instances.clear()
