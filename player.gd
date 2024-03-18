extends CharacterBody2D

@onready var cam = $Camera2D
@export var bullet :PackedScene

const SPEED = 50
#const ROTATION_SPEED = 5
var can_fire = true

func _ready():
	cam.enabled = is_multiplayer_authority()
	spawn()
	
func _physics_process(delta):
	if !is_multiplayer_authority():
		return

	$"../gunrotation".look_at(get_global_mouse_position())

	var direction = Input.get_vector("left", "right", "up","down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	'''
	TANK CONTROLS
	
	var rot_dir = 0
	if Input.is_action_pressed('right'):
		rot_dir += 1
	if Input.is_action_pressed('left'):
		rot_dir -= 1
	rotation += ROTATION_SPEED * rot_dir * delta
	velocity = Vector2()
	if Input.is_action_pressed('up'):
		velocity = Vector2(SPEED, 0).rotated(rotation)
	if Input.is_action_pressed('down'):
		velocity = Vector2(-SPEED/2, 0).rotated(rotation)
	'''
	
	if Input.is_action_pressed('fire') and can_fire:
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
	b.global_position = $"../gunrotation/bulletSpawn".global_position
	b.rotation_degrees = $"../gunrotation".rotation_degrees
	get_tree().root.add_child(b)
	can_fire = false
	$fire_cooldown.start()
	
func _on_area_2d_area_entered(area):
	queue_free()

func _on_fire_cooldown_timeout():
	can_fire = true
	
func hit():
	spawn()

func spawn():
	var spawnLocation = Globals.players[str(multiplayer.get_unique_id())+"spawnPoint"]
	self.global_position = get_node(spawnLocation).global_position

	
