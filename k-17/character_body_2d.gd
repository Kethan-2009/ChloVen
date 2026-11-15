extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const JUMP_VELOCITY_COMPRESS = -800.0
var score: int = 0
@onready var base_sprite: Sprite2D = $"base-sprite"
@onready var compressed_sprite: Sprite2D = $"compressed-sprite"
@onready var drum: AudioStreamPlayer = $drum


func _physics_process(delta: float) -> void:
	# Add the gravity.	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_pressed("compress") and Input.is_action_pressed("super-jump"):
		velocity.y = JUMP_VELOCITY_COMPRESS

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if Input.is_action_just_pressed("compress"):
		base_sprite.visible = false
		compressed_sprite.visible = true
		drum.play()
	if Input.is_action_just_released("compress"):
		base_sprite.visible = true
		compressed_sprite.visible = false
		drum.stop()
	move_and_slide()
