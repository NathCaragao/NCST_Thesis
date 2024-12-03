#extends Node2D
#@export var bgm_tracks: Dictionary = {
	#"level_3.tscn": "CursedVillage",
	#"level_4.tscn": "Dark_dungeon",
	#"level_5.tscn": "ghost_castle",
	#"level_6.tscn": "hall_of_the_king",
	#"level_7.tscn": "inthecastle"
#}  # Mapping scenes to playlist tracks
#
#var current_bgm: String = ""  # Track currently playing
#
#func _ready() -> void:
	## Automatically play the BGM for the current scene
	#play_bgm_for_scene(get_tree().current_scene.name)
#
## This function will be called to play the BGM for the current scene
#func play_bgm_for_scene(scene_name: String) -> void:
	## Check if the scene has a corresponding track in the playlist
	#if scene_name in bgm_tracks:
		#var track_name = bgm_tracks[scene_name]
		#
		#if track_name != current_bgm:
			#current_bgm = track_name
			#play_bgm(track_name)
	#else:
		#print("No BGM found for scene:", scene_name)
#
## Function to play the BGM by selecting the track from the playlist
#func play_bgm(track_name: String) -> void:
	## Check if the AudioStreamPlayer has a playlist and that it contains the track
	#if audio_player.playlist.size() > 0:
		#for i in range(audio_player.playlist.size()):
			#if audio_player.playlist[i].resource_name == track_name:
				#audio_player.play(i)
				#print("Playing BGM:", track_name)
				#return
	#print("Error: Track not found in playlist:", track_name)
