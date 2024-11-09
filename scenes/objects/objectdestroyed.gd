extends StaticBody2D
@onready var sprite_2d = $Sprite2D
@onready var rigidcrate = $"../LargeCrate"

signal destroy_the_destroyer

func destroy_obj():
	sprite_2d.queue_free()
	$CollisionShape2D.queue_free()
	emit_signal("destroy_the_destroyer")




func _on_destroyed_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group("destroyer"):
		print("sabog")
		destroy_obj()
