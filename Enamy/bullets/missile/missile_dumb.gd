extends Area2D

export var SPEED = 350

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO

func start(_transform, _target):
	global_transform = _transform
	velocity = transform.x * SPEED

func _physics_process(delta):
	velocity += acceleration * delta
	velocity = velocity.clamped(SPEED)
	rotation = velocity.angle()
	position += velocity * delta

func _on_Lifetime_timeout():
	queue_free()

func _on_missile_dumb_body_entered(_body):
	queue_free()
