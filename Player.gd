extends KinematicBody

onready var head = $Head
onready var camera = $Head/Camera
onready var raycast = $Head/Camera/RayCast
onready var block_outline = $BlockOutline

var camera_x_rotation = 0

const mouse_sensitivity = 0.3
const movement_speed = 5
const gravity = 30
const jump_velocity = 10

var velocity = Vector3()

var paused = false

signal place_block(pos, t)
signal break_block(pos)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if Input.is_action_just_pressed("Pause"):
		paused = not paused
		if paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# TODO: [Pause Menu] Create menu interface for player
	if paused:
		return
	
	if event is InputEventMouseMotion:
		head.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		
		var delta_x = event.relative.y * mouse_sensitivity

		# Clamp camera rotation to simulate proper head movement
		if camera_x_rotation + delta_x > -90 and camera_x_rotation + delta_x < 90:
			camera.rotate_x(deg2rad(-delta_x))
			camera_x_rotation += delta_x

func _physics_process(delta):
	if paused:
		return

	# Vectors for identifying where player is trying to move towards
	var direction = Vector3()
	# Basis can be scaled and used towards direction
	var basis = head.get_global_transform().basis
	
	# WASD Movement
	if Input.is_action_pressed("Forward"):
		direction -= basis.z
	if Input.is_action_pressed("Backward"):
		direction += basis.z
	if Input.is_action_pressed("Left"):
		direction -= basis.x
	if Input.is_action_pressed("Right"):
		direction += basis.x
	
	# Space Bar Movement
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity
	
	velocity.z = direction.z * movement_speed
	velocity.x = direction.x * movement_speed
	velocity.y -= gravity * delta

	velocity = move_and_slide(velocity, Vector3.UP)
	
	# Check if raycast node is colliding with a block
	if raycast.is_colliding():
		var norm = raycast.get_collision_normal()
		var pos = raycast.get_collision_point() - norm * 0.5

		# Get block position
		var bx = floor(pos.x) + 0.5
		var by = floor(pos.y) + 0.5
		var bz = floor(pos.z) + 0.5
		var bpos = Vector3(bx, by, bz) - self.translation

		block_outline.translation = bpos
		block_outline.visible = true

		if Input.is_action_just_pressed("Break"):
			emit_signal("break_block", pos)
		if Input.is_action_just_pressed("Place"):
			# TODO: [Inventory System] Place whatever is on hand
			emit_signal("place_block", pos + norm, gamestate.STONE)

	else:
		block_outline.visible = false
