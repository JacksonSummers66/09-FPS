extends KinematicBody

onready var Camera = $Pivot/Camera
var Bullet = preload("res://Scenes/Bullet.tscn")

var velocity = Vector3()
var gravity = -9.8
var speed = 8
var mouse_sensitivity = 0.002
var mouse_range = 1.2
var jump = 10
var jumping = false

var health = 200

func _ready():
	pass
	
func take_damage(d):
	health -= d
	if health <= 0:
		queue_free()
	
func get_input():
	var input_dir = Vector3()
	if Input.is_action_pressed("Forward"):
		input_dir += -Camera.global_transform.basis.z
	if Input.is_action_pressed("Back"):
		input_dir += Camera.global_transform.basis.z
	if Input.is_action_pressed("Left"):
		input_dir += -Camera.global_transform.basis.x
	if Input.is_action_pressed("Right"):
		input_dir += Camera.global_transform.basis.x
	if Input.is_action_pressed("jump"):
		jumping = true
	input_dir = input_dir.normalized()
	return input_dir
		
func _physics_process(delta):
	velocity.y += gravity * delta
	var desired_velocity = get_input() * speed
	
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	if jumping and is_on_floor():
		velocity.y = jump
	jumping = false
	
	velocity = move_and_slide(velocity, Vector3.UP, true)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -mouse_range, mouse_range)
	if event.is_action_pressed("Shoot"):
		var b = Bullet.instance()
		b.start($Pivot/Muzzle.global_transform)
		get_node("/root/Game/Bullets").add_child(b)
