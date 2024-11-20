class_name Hurtbox
extends Area2D

# references


func _init() -> void:
	collision_layer = 0
	collision_mask = 2 # allows the hurtbox to detect hitbox

func _ready() -> void:
	# signals to connect the interaction of collisions
	connect("area_entered", Callable(self, "on_atk_entered"))
	connect("area_entered", Callable(self, "on_skill_entered"))
	connect("area_entered", Callable(self, "on_arrow_hit"))
	connect("area_entered", Callable(self, "on_fire_hazard"))
	connect("area_entered", Callable(self, "on_spike_wheel"))
	connect("area_entered", Callable(self, "on_razor_hit"))
	connect("area_entered", Callable(self, "on_death_zone"))

# BASIC ATK hitbox
func on_atk_entered(area: Area2D) -> void:
	if area == null:
		return
	
	
	# to differentiate types of attacks
	if area is Hitbox:
		if owner.has_method("take_damage"):
			owner.take_damage(area.total_dmg)

# skill hitbox
func on_skill_entered(skill_hitbox : Area2D) -> void:
	if skill_hitbox == null:
		return
	
	# to differentiate types of attacks
	if skill_hitbox is SkillHitbox:
		if owner.has_method("take_damage"):
			owner.take_damage(skill_hitbox.skill_dmg)

# arrow projectile
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

# spike wheel obstacle
func on_spike_wheel(spike_hitbox : Area2D) -> void:
	if spike_hitbox == null:
		return
	
	if spike_hitbox is SpikeHitbox:
		if owner.has_method("take_damage"):
			owner.take_damage(spike_hitbox.spike_dmg)

# circular razor obstacle
func on_razor_hit(razor_hitbox : Area2D) -> void:
	if razor_hitbox == null:
		return
	
	if razor_hitbox is RazorHitbox:
		if owner.has_method("take_damage"):
			owner.take_damage(razor_hitbox.razor_dmg)

# Death Zone Area
func on_death_zone(death_zone: Area2D) -> void:
	if death_zone == null:
		return
	
	if death_zone is DeathZone:
		if owner.has_method("take_damage"):
			owner.take_damage(death_zone.insta_dmg)
