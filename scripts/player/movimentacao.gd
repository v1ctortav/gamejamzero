# movimentacao.gd
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

var direcao: Vector2 = Vector2.ZERO
var ultima_direcao: Vector2 = Vector2.DOWN

var corpo: CharacterBody2D

var aceleracao: float
var desaceleracao: float

func _instanciar(_vel, _corpo, _aceleracao, _desaceleracao):
	vel = _vel
	corpo = _corpo
	aceleracao = _aceleracao
	desaceleracao = _desaceleracao

	_go_to_idle_state()

func _set_state(_delta):
	delta = _delta

	match status:
		estados.idle:
			_idle_state()

		estados.andando:
			_andando_state()

		estados.interagindo:
			interacao._interagindo_state()

	corpo.move_and_slide()

func _mover():
	if not corpo.can_move:
		corpo.velocity = Vector2.ZERO
		return

	_atualizar_direcao()

	var velocidade_alvo = direcao * vel

	# Movimento suave
	corpo.velocity = corpo.velocity.move_toward(
		velocidade_alvo,
		aceleracao * delta
	)

	# Desaceleração suave
	if direcao == Vector2.ZERO:
		corpo.velocity = corpo.velocity.move_toward(
			Vector2.ZERO,
			desaceleracao * delta
		)

func _atualizar_direcao():
	var input_x = Input.get_axis("esquerda", "direita")
	var input_y = Input.get_axis("cima", "baixo")

	direcao = Vector2(input_x, input_y)

	# Corrige velocidade diagonal
	if direcao.length() > 1:
		direcao = direcao.normalized()

	# Salva última direção válida
	if direcao != Vector2.ZERO:
		ultima_direcao = direcao

	# Flip horizontal
	if direcao.x < 0:
		animacao.flip_h = true
	elif direcao.x > 0:
		animacao.flip_h = false

func _go_to_idle_state():
	status = estados.idle

	# Idle baseado na última direção
	if abs(ultima_direcao.x) > abs(ultima_direcao.y):
		animacao.play("idle_lados")
		animacao.flip_h = ultima_direcao.x < 0

	elif ultima_direcao.y < 0:
		animacao.play("idle_cima")

	else:
		animacao.play("idle_baixo")

func _idle_state():
	_mover()

	if direcao != Vector2.ZERO:
		_go_to_andando_state()
		return

	if Input.is_action_just_pressed("interagir"):
		if interacao.objeto_interacao != null:
			interacao._interagir()

func _go_to_andando_state():
	status = estados.andando

func _andando_state():
	_mover()

	_atualizar_animacao_movimento()

	if direcao == Vector2.ZERO and corpo.velocity.length() < 1:
		corpo.velocity = Vector2.ZERO
		_go_to_idle_state()

func _atualizar_animacao_movimento():
	# Prioridade horizontal
	if abs(direcao.x) > abs(direcao.y):
		if animacao.animation != "lados":
			animacao.play("lados")

	else:
		if direcao.y < 0:
			if animacao.animation != "cima":
				animacao.play("cima")

		elif direcao.y > 0:
			if animacao.animation != "baixo":
				animacao.play("baixo")
