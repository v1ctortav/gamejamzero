extends Node
class_name Movimentacao

@onready var interacao: Interacao = $"../interacao"

@onready var animacao: AnimatedSprite2D = $"../animacao"

enum estados {
	idle,
	andando,
	interagindo
}

var status: estados
var delta: float
var vel: float
var direcao_x
var direcao_y
var ultima_direcao: Vector2 = Vector2.ZERO
var corpo: CharacterBody2D
var aceleracao: float
var desaceleracao: float

func _instanciar(_vel, _corpo, _aceleracao, _desaceleracao):
	self.vel = _vel
	self.corpo = _corpo
	self.aceleracao = _aceleracao
	self.desaceleracao = _desaceleracao
	_go_to_idle_state()

func _set_state(delta):
	self.delta = delta
	match status:
		estados.idle:
			_idle_state()
		estados.andando:
			_andando_state()
		estados.interagindo:
			interacao._interagindo_state()
	corpo.move_and_slide()

func _mover():
	_atualizar_direcao()
	if direcao_x:
		corpo.velocity.x = move_toward(corpo.velocity.x, direcao_x * vel, aceleracao * delta)
	else:
		corpo.velocity.x = move_toward(corpo.velocity.x, 0, desaceleracao * delta)
	if direcao_y:
		corpo.velocity.y = move_toward(corpo.velocity.y, direcao_y * vel, aceleracao * delta)
	else:
		corpo.velocity.y = move_toward(corpo.velocity.y, 0, desaceleracao * delta)

func _atualizar_direcao():
	var input_x = Input.get_axis("esquerda", "direita")
	var input_y = Input.get_axis("cima", "baixo")
	
	if input_x != 0 and input_y != 0:
		direcao_x = 0
		direcao_y = 0
	else:
		direcao_x = input_x
		direcao_y = input_y
		
	if direcao_x < 0:
		animacao.flip_h = true
	elif direcao_x > 0:
		animacao.flip_h = false
		
	if direcao_y < 0 and direcao_x == 0:
		animacao.play("cima")
	elif direcao_y > 0 and direcao_x == 0:
		animacao.play("baixo")

	if direcao_x != 0 or direcao_y != 0:
		ultima_direcao = Vector2(direcao_x, direcao_y)

func _go_to_idle_state():
	status = estados.idle
	if abs(ultima_direcao.x) > abs(ultima_direcao.y):
		animacao.play("idle_lados")
		animacao.flip_h = ultima_direcao.x < 0
	elif ultima_direcao.y < 0:
		animacao.play("idle_cima")
	else:
		animacao.play("idle_baixo")
func _idle_state():
	_mover()
	if corpo.velocity.x != 0 or corpo.velocity.y != 0:
		_go_to_andando_state()
		return
	if Input.is_action_just_pressed("interagir") and interacao.objeto_interacao != null:
		interacao._go_to_interagir_state()
		return

func _go_to_andando_state():
	status = estados.andando
func _andando_state():
	_mover()
	if Input.is_action_pressed("esquerda") or Input.is_action_pressed("direita"):
		animacao.play("lados")
	if corpo.velocity.x == 0 and corpo.velocity.y == 0:
		_go_to_idle_state()
		return
