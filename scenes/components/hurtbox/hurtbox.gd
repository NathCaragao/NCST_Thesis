class_name Hurtbox
extends Area2D

# references


func _init() -> void:
	collision_layer = 0
	collision_mask = 2 # allows the hurtbox to detect hitbox

func _ready() -> void:
	connect("area_entered", Callable(self, "on_atk_entered"))
	connect("area_entered", Callable(self, "on_skill_entered"))
	connect("area_entered", Callable(self, "on_arrow_hit"))
	connect("area_entered", Callable(self, "on_fire_hazard"))

# BASIC ATK hitbox
func on_atk_entered(area: Area2D) -> void:
	if area == null:
		return
	
	
	# to differentiate types of attacks
	if area is Hitbox:
		if owner.has_method("take_damage"):
			owner.take_damage(area.total_dmg)

func on_skill_entered(skill_hitbox : Area2D) -> void:
	if skill_hitbox == null:
		return
	
	# to differentiate types of attacks
	if skill_hitbox is SkillHitbox:
		if owner.has_method("take_damage"):
			owner.take_damage(skill_hitbox.skill_dmg)

func on_arrow_hit(projectile: Area2D) -> void:
	if projectile == null:
		return
	
	
	if projectile is ProjectileHitbox:
		if owner.has_method("take_damage"):
			if projectile.already_hit == false:
				owner.take_damage(projectile.projectile_dmg)
				projectile.on_collide()

# fire hazard obstacle
func on_fire_hazard(fire_hitbox : Area2D) -> void:
	if fire_hitbox == null:
		return
	
	if fire_hitbox is FireHazzardHitbox:
		if owner.has_method("take_damage"):
			owner.take_damage(fire_hitbox.fire_dmg)
