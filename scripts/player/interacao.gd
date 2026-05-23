extends Node
class_name Interacao

var pode_interagir = true
var objeto_interacao: Node2D
@onready var movimentacao: Movimentacao = $"../movimentacao"

func _interagir():
	if pode_interagir and objeto_interacao != null:
		if objeto_interacao.has_method("_interagir"):
			objeto_interacao._interagir()
			_go_to_interagir_state()
			pode_interagir = false

func _go_to_interagir_state():
	movimentacao.status = movimentacao.estados.interagindo
func _interagindo_state():
	_interagir()
	movimentacao.corpo.velocity = Vector2.ZERO
	if Input.is_action_just_pressed("interagir"):
		movimentacao._go_to_idle_state()
		pode_interagir = true


func _on_hitbox_interacao_area_entered(area: Area2D) -> void:
	if area.is_in_group("objetos_interativos"):
		objeto_interacao = area.get_parent()


func _on_hitbox_interacao_area_exited(area: Area2D) -> void:
	if area.is_in_group("objetos_interativos"):
		objeto_interacao = null
