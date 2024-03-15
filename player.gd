extends CharacterBody2D

@onready var cam = $Camera2D
@export var bullet :PackedScene

const SPEED = 300.0

func _ready():
	cam.enabled = is_multiplayer_authority()

func _physics_process(delta):
	if !is_multiplayer_authority():
		return
	
	# Get the input direction and handle the movement/deceleration.
	$gunrotation.look_at(get_global_mouse_position())
	
	var direction = Input.get_vector("left", "right", "up","down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	if Input.is_action_just_pressed("fire"):
		fire.rpc()
	
	#animatedSprite2d
	if velocity.x > .1:
		$AnimatedSprite2D.animation = "run"
		$AnimatedSprite2D.flip_h = false
	elif velocity.x < -.1:
		$AnimatedSprite2D.animation = "run"
		$AnimatedSprite2D.flip_h = true
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "run"
	else:
		$AnimatedSprite2D.animation = "idle"
	
	$AnimatedSprite2D.play($AnimatedSprite2D.animation)

	
	move_and_slide()

@rpc("any_peer","call_local")
func fire():
	var b = bullet.instantiate()
	print("fire" + str(multiplayer.get_unique_id()))
	b.global_position = $gunrotation/bulletSpawn.global_position
	b.rotation_degrees = $gunrotation.rotation_degrees
	get_tree().root.add_child(b)
	
	
