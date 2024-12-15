extends Control


@onready var heroes_section: ColorRect = $HeroesSection
#heroes
@onready var hercules_prof: ColorRect = $HerculesProf
@onready var atalanta_prof = $AtalantaProf
@onready var hypolita = $Hypolita

@onready var gods_and_goddesses = $"Gods and Goddesses"
#god_and_goddesses
@onready var artemis_prof = $ArtemisProf
@onready var athena_prof = $AthenaProf
@onready var hades = $Hades
@onready var prometheus = $Prometheus


@onready var monster_and_creatures = $"monster and creatures"
#monsters
@onready var nemean_lion_prof = $Nemean_lionProf
@onready var lernean_hydra_prof = $Lernean_hydraProf
@onready var cerynian_hind_prof = $Cerynian_hindProf
@onready var erymanthian_boar_prof = $Erymanthian_boarProf

@onready var _12_labors = $"12labors"
#labors
@onready var _1_st_labor = $"1st labor"
@onready var _2_nd_labor = $"2nd labor"
@onready var _3_rd_labor = $"3rd labor"
@onready var _4_th_labor = $"4th labor"


func _ready() -> void:
	ScoreUi.get_node('CanvasLayer').hide()

# close_btn
func almanac_close() -> void:
	# Create a new tween
	var tween = create_tween()
	
	# Get the screen size
	var screen_size = get_viewport_rect().size
	
	# Animate the window moving from center to bottom
	tween.tween_property(self, "position:y", screen_size.y, 0.3) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_IN)
	
	# After the animation completes, hide the window
	tween.tween_callback(func(): visible = false)


func _on_heroes_btn_pressed() -> void:
	heroes_section.visible = true
	
func _on_hercules_btn_pressed() -> void:
	# hide other windows
	#heroes_section.visible = false
	# show active window
	hercules_prof.visible = true

# heroes section back button
func _on_hs_backbtn_pressed() -> void:
	heroes_section.visible = false

# hercules profile back btn
func _on_hercules_back_btn_pressed() -> void:
	hercules_prof.visible = false



func _on_atalanta_btn_pressed():
	atalanta_prof.visible = true



func _on_atalanta_back_btn_pressed():
	atalanta_prof.visible = false


func _on_gg_backbtn_pressed():
	gods_and_goddesses.visible = false


func _on_gods_btn_pressed():
	gods_and_goddesses.visible = true
	
func _on_artemis_pressed():
	artemis_prof.visible = true


func _on_athena_pressed():
	athena_prof.visible = true


func _on_back_btn_pressed():
	artemis_prof.visible = false
	
func _on_hades_pressed():
	hades.visible = true


func _on_prometheus_pressed():
	prometheus.visible = true


func _on_enemies_btn_pressed():
	monster_and_creatures.visible = true
	
func _on_nermean_lion_pressed():
	nemean_lion_prof.visible = true


func _on_lernean_hydra_pressed():
	lernean_hydra_prof.visible = true


func _on_hind_of_ceryneia_pressed():
	cerynian_hind_prof.visible = true


func _on_erymanthian_boar_pressed():
	erymanthian_boar_prof.visible = true


func _on_mm_backbtn_pressed():
	monster_and_creatures.visible = false


func _on_nermean_back_btn_pressed():
	nemean_lion_prof.visible = false


func _on_lernean_back_btn_pressed():
	lernean_hydra_prof.visible = false
	


func _on_cerynian_back_btn_pressed():
	cerynian_hind_prof.visible = false
	


func _on_erymanthian_back_btn_pressed():
	erymanthian_boar_prof.visible = false
	


func _on_hypolita_back_btn_pressed():
	hypolita.visible = false


func _on_hypolita_pressed():
	hypolita.visible= true


func _on_st_labor_pressed():
	_1_st_labor.visible = true


func _on_nd_labor_pressed():
	_2_nd_labor.visible = true


func _on_ll_backbtn_pressed():
	_12_labors.visible = false


func _on_labors_btn_pressed():
	_12_labors.visible = true

func _on_rd_labor_pressed():
	_3_rd_labor.visible = true


func _on_th_labor_pressed():
	_4_th_labor.visible = true


func _on_st_back_btn_pressed():
	_1_st_labor.visible = false


func _on_nd_back_btn_pressed():
	_2_nd_labor.visible = false


func _on_rd_back_btn_pressed():
	_3_rd_labor.visible = false


func _on_tht_back_btn_pressed():
	_4_th_labor.visible = false


func _on_athena_back_btn_pressed():
	athena_prof.visible = false


func _on_hades_back_btn_pressed():
	hades.visible = false


func _on_prometheus_back_btn_pressed():
	prometheus.visible = false
