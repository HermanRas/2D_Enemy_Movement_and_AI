extends Area2D

export (PackedScene) var Missile = load("res://Enamy/bullets/missile/smart.tscn")
export (int) var detect_raduis = 300
export (float) var rotation_speed = PI
export (float) var fire_rate = 0.6

var vis_color = Color(.867, .91, 247, 0.1)
var laser_color = Color(1.0, 0.0, 0.0, 1.0)
var target = null
var hit_pos = Vector2() 
var can_shoot = true

func _ready():
	var shape = CircleShape2D.new()
	shape.radius = detect_raduis
	$TargetArea.shape = shape
	$ShootTimer.wait_time = fire_rate

func _process(_delta):
	update()
	if target:
		aim()

func aim():
	hit_pos = []
	var space_State = get_world_2d().direct_space_state
	var target_extents = target.get_node('CollisionShape2D').shape.extents - Vector2(-5,-5)
	var nw = target.position + Vector2(-target_extents.x, -target_extents.x)
	var se = target.position + Vector2(target_extents.x, target_extents.x)
	var ne = target.position + Vector2(target_extents.x, -target_extents.x)
	var sw = target.position + Vector2(-target_extents.x, target_extents.x)
	for pos in [target.position,nw,se,ne,sw]:
		var result = space_State.intersect_ray(position,pos,[self],collision_mask)
		if result:
			hit_pos.append(result.position)
			if result.collider.name == 'Player':
				$Sprite.self_modulate = Color(1.0 ,0.5 ,0.5 ,1.0)
				rotation = (target.position - position).angle()
				if can_shoot:
					shoot(pos)
				return

func shoot(_target):
	var b = Missile.instance()
	b.start(transform,_target)
#	b.scale = Vector2(0.5,0.5)
	get_parent().add_child_below_node(get_node("Sprite"),b,false)
	can_shoot = false
	$ShootTimer.start()

func _draw():
	draw_circle(Vector2(),detect_raduis,vis_color)
	if target:
		for hit in hit_pos:
			draw_circle((hit - position).rotated(-rotation), 5, laser_color)
			draw_line(Vector2(), (hit - position).rotated(-rotation), laser_color)

func _on_Turret_body_entered(body):
	if target:
		return
	if body.is_in_group("Player"):
		target = body
	
func _on_Turret_body_exited(body):
	if body == target:
		target = null
		$Sprite.self_modulate = Color(1.0 ,1.0 ,1.0 ,1.0)

func _on_ShootTimer_timeout():
	can_shoot = true
