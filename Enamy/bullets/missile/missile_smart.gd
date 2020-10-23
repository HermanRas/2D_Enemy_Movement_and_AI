extends Area2D

export var SPEED = 350
export var STEER_FORCE = 50.0

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var target = null

func start(_transform, _target):
	global_transform = _transform
	velocity = transform.x * SPEED
	target = _target

func seek():
	var steer = Vector2.ZERO
	if target:
		var desired_velocity = (target - position).normalized() * SPEED
		steer = (desired_velocity - velocity).normalized() * STEER_FORCE
	return steer

func _physics_process(delta):
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.clamped(SPEED)
	rotation = velocity.angle()
	position += velocity * delta

func _on_Lifetime_timeout():
	queue_free()

func _on_missile_dumb_body_entered(_body):
	queue_free()
