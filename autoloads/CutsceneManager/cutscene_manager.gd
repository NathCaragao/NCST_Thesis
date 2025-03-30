extends Node
var cutscene_instances = {}
var canvas_layer: CanvasLayer = null
func set_canvas_layer(canvas_layer_node: CanvasLayer):
	canvas_layer = canvas_layer_node
func add_cutscene(cutscene_path, cutscene_name):
	var cutscene = load(cutscene_path).instantiate()
	cutscene_instances[cutscene_name] = cutscene
	if canvas_layer:
		canvas_layer.add_child(cutscene)
func play_cutscene(cutscene_name):
	if cutscene_name in cutscene_instances:
		cutscene_instances[cutscene_name].play()
		print("cutscene playing: ", cutscene_name)
func stop_cutscene(cutscene_name):
	if cutscene_name in cutscene_instances:
		cutscene_instances[cutscene_name].close()
func clear_cutscenes():
	for cutscene_name in cutscene_instances:
		if canvas_layer:
			canvas_layer.remove_child(cutscene_instances[cutscene_name])
	cutscene_instances.clear()
