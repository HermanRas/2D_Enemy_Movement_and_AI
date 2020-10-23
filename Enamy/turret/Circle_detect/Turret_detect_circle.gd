extends Area2D

export (PackedScene) var Missile = load("res://Enamy/bullets/missile/missile-dumb.tscn")
export (int) var detect_raduis = 300
export (float) var rotation_speed = PI
export (float) var fire_rate = 0.5

var vis_color = Color(.867, .91, 247, 0.1)
var target = null
var can_shoot = true

func _ready():
	var shape = CircleShape2D.new()
	shape.radius = detect_raduis
	$TargetArea.shape = shape
	$ShootTimer.wait_time = fire_rate

func _process(_delta):
	update()
	if target:
		rotation = (target.position - position).angle()
		if (can_shoot):
			shoot(target.position )

func shoot(_target):
	var b = Missile.instance()
	b.start(transform, _target)
	get_parent().add_child(b)
	can_shoot = false
	$ShootTimer.start()
	
func _draw():
	draw_circle(Vector2(),detect_raduis,vis_color)

func _on_Turret_body_entered(body):
	if target:
		return
	if body.is_in_group("Player"):
		target = body
		$Sprite.self_modulate = Color(1.0 ,0.5 ,0.5 ,1.0)
	
func _on_Turret_body_exited(body):
	if body == target:
		target = null
		$Sprite.self_modulate = Color(1.0 ,1.0 ,1.0 ,1.0)

func _on_ShootTimer_timeout():
	can_shoot = true
