extends Area2D

var direction : Vector2

func setUp(pos,dir):
	position = pos+dir*16
	direction = dir
	

func _physics_process(delta: float) -> void:
	position+=direction*30*delta
