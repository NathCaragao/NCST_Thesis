extends RigidBody2D
@onready var sprite_2d = $Sprite2D
@onready var rigidcrate = $"."
@onready var lvl4_crate = $"."

signal gumanaba
func _on_log_destroy_the_destroyer():
	print("i am gone")
	sprite_2d.queue_free()
	lvl4_crate.queue_free()
	$CollisionShape2D.queue_free()
	emit_signal("gumanaba")
