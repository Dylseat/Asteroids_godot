@tool
extends Area2D
class_name Asteroid

var direction = Vector2.RIGHT

enum SIZE{
	SMALL,
	MEDIUM,
	BIG
}

@export var size : SIZE = SIZE.BIG:
	set(value):
		if value != size:
			size = value
			size_changed.emit()

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


@export var speed = 200.0
@export var torque = 50.0

@export var asteroid_size_array : Array[AsteroidSize]

signal size_changed

func _ready() -> void:
	if Engine.is_editor_hint():
		set_physics_process(false)
		
	size_changed.connect(update_size)

func _physics_process(delta: float) -> void:
	var velocity = speed * direction * delta
	global_position += velocity
	
	rotation_degrees += torque * delta

func update_size() -> void:
	assert(size in range(asteroid_size_array.size()), "invalide size valid " + str(size))
	
	var asteroid_size = asteroid_size_array[size]
	
	sprite.texture = asteroid_size.texture
	collision_shape_2d.shape = asteroid_size.shape

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.destroy()

func destroy() -> void:
	queue_free()
