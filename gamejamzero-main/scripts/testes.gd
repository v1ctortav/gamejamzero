extends Node2D

@onready var dialogo_ui = $dialogo/PanelContainer
@onready var jogador = $player

var dialogos = {
	"vizinho_generico": {
		"texto": "Boa tarde, oficial. O bairro anda estranho ultimamente...",
		"opcoes": [
			{
				"texto": "Viu algo suspeito?",
				"resposta_vizinho": "Ontem à noite ouvi passos perto da praça. Parecia alguém correndo."
			},
			{
				"texto": "Conhece a vítima?",
				"resposta_vizinho": "Só de vista. Ela morava aqui fazia alguns meses."
			},
			{
				"texto": "Alguém entrou na sua casa?",
				"resposta_vizinho": "Não, mas encontrei minha porta aberta quando acordei."
			}
		]
	}
}


func _ready():
	dialogo_ui.dialogo_encerrado.connect(_on_dialogo_encerrado)

	$caixa.evidencia_escaneada.connect(_on_vizinho_dialogo)

func iniciar_dialogo(id_do_vizinho: String):
	var dialogo_data = dialogos.get(id_do_vizinho)

	if dialogo_data != null:
		jogador.travar_movimento(true)

		dialogo_ui.start_dialogue(dialogo_data)

func _on_dialogo_encerrado():
	jogador.travar_movimento(false)

func _on_vizinho_dialogo(id_do_vizinho):
	iniciar_dialogo(id_do_vizinho)
