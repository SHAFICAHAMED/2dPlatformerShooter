extends CharacterBody2D


var direction_x: float
var speed = 50
@export var jump_strength : =10
@export var gravity : =10
@onready var shoot_timer: Timer = $ShootTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal shoot(pos:Vector2,dir:Vector2)

const gun_directions = {
	Vector2i(1,0):0,
	Vector2i(1,1):1,
	Vector2i(0,1):2,
	Vector2i(-1,1):3,
	Vector2i(-1,0):4,
	Vector2i(-1,-1):5,
	Vector2i(0,-1):6,
	Vector2i(1,-1):7,
}

func get_input():
	direction_x  = Input.get_axis("left","right")
	if Input.is_action_just_pressed("jump"):
		velocity.y = -jump_strength
	if Input.is_action_just_pressed("shoot") and shoot_timer.time_left == 0:
		shoot.emit(position,get_local_mouse_position().normalized())
		shoot_timer.start()
		
func apply_gravity(delta):
	velocity.y+=gravity * delta
	
	
func _physics_process(delta: float) -> void:
	get_input()
	velocity.x = direction_x*speed
	apply_gravity(delta)
	move_and_slide()
	animation()
func animation():
	$Legs.flip_h  = direction_x<0
	if is_on_floor():
		animation_player.current_animation = "run" if direction_x else "idle"
	else:
		animation_player.current_animation = "jump"
	var raw_direction = get_local_mouse_position().normalized()
	var adjust_direction = Vector2i(round(raw_direction.x),round(raw_direction.y))
	$Torso.frame = gun_directions[adjust_direction]
