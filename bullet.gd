extends CharacterBody2D

const SPEED = 100.0
var bounce = 2

func _ready():
	velocity = Vector2(SPEED,0).rotated(rotation)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		bounce -= 1
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit()
			queue_free()
	if bounce <= 0:
		queue_free()
