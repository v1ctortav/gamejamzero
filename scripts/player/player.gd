extends CharacterBody2D

@onready var movimentacao: Movimentacao = $movimentacao
@onready var interacao: Interacao = $interacao

@export var vel = 120
@export var aceleracao = 800
@export var desaceleracao = 800

func _ready() -> void:
	movimentacao._instanciar(vel, self, aceleracao, desaceleracao)

func _physics_process(delta: float) -> void:
	movimentacao._set_state(delta)
