extends Area2D

export var SPEED = 350
export var STEER_FORCE = 50.0

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var targetPos = null
var targetObject = null

func start(_transform, _targetPos, _targetObject = null):
	global_transform = _transform
	velocity = transform.x * SPEED
	targetPos = _targetPos
	targetObject = _targetObject

func seek():
	var steer = Vector2.ZERO
	if targetPos:
		var desired_velocity = (targetPos - position).normalized() * SPEED
		steer = (desired_velocity - velocity).normalized() * STEER_FORCE
	#Update Pos if Locked target
	if targetObject:
		targetPos = targetObject.position
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
