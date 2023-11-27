extends Node2D
const FootprintTile = preload("res://FootprintTile.gd")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# CONST VARIABLES

const default_scale = Vector2(0.5, 0.5)
const tile_rotation_offset = PI / 2

export var radius_outer = 700
export var radius_inner = 550

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _init(parent = null) -> void:
	assert(parent != null)
	scale = default_scale
	var i = 0
	var delta_theta_outer = 2 * PI / gamestate.num_outer_tiles
	var delta_theta_inner = 2 * PI / gamestate.num_inner_tiles
	
	while i < gamestate.num_outer_tiles + gamestate.num_inner_tiles:
		var tile = FootprintTile.new(i, true)
		var connect_val = tile.connect("display_footprint", parent, "display_footprint_tile")
		assert(connect_val == OK)
		var radius = (radius_outer if tile.in_outer_ring_layer() else radius_inner)
		var theta = (i % gamestate.num_outer_tiles) * \
			(delta_theta_outer if tile.in_outer_ring_layer() else delta_theta_inner)
		tile.position = polar2cartesian(radius, theta)
		tile.rotation = theta + tile_rotation_offset
		tile.visible = false
		add_child(tile)
		i += 1

func show_tile(footprint_num: int, round_num: int) -> void:
	get_child(footprint_num + gamestate.tiles_per_round * round_num).visible = true
	
func show_round(round_num: int) -> void:
	var i = 0
	while i < gamestate.tiles_per_round:
		self.show_tile(i, round_num)
		i += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
