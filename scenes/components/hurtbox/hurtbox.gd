class_name Hurtbox
extends Area2D

# references


func _init() -> void:
	collision_layer = 0
	collision_mask = 2 # allows the hurtbox to detect hitbox

func _ready() -> void:
	connect("area_entered", Callable(self, "on_atk_entered"))

# BASIC ATK hitbox
func on_atk_entered(area: Area2D) -> void:
	# to differentiate types of attacks
	if area is Hitbox:
		if owner.has_method("take_damage"):
			owner.take_damage(area.total_dmg)
	
	elif area is SkillHitbox:
		if owner.has_method("take_damage"):
			owner.take_damage(area.skill_dmg)
	elif area == null:
		return


#func on_skill_entered(skill_hitbox : Area2D) -> void:
	#if skill_hitbox == null:
		#return
	#
	## to differentiate types of attacks
	#if skill_hitbox is SkillHitbox:
		#if owner.has_method("take_damage"):
			#owner.take_damage(skill_hitbox.skill_dmg)
