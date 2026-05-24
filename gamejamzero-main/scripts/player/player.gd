# player.gd
extends CharacterBody2D

@onready var movimentacao: Movimentacao = $movimentacao
@onready var interacao: Interacao = $interacao

@export var vel = 120
@export var aceleracao = 800
@export var desaceleracao = 800

var can_move: bool = true

func _ready() -> void:
	movimentacao._instanciar(
		vel,
		self,
		aceleracao,
		desaceleracao
	)

func _physics_process(delta: float) -> void:
	movimentacao._set_state(delta)

func travar_movimento(travado: bool):
	can_move = not travado

	if travado:
		movimentacao.status = movimentacao.estados.interagindo

	else:
		interacao.liberar_interacao()
		movimentacao._go_to_idle_state()
