extends PanelContainer

signal dialogo_encerrado

@onready var escolhas: VBoxContainer = $VBoxContainer/VBoxContainer
@onready var timer_dialogo: Timer = $timer_dialogo
@onready var label: RichTextLabel = $VBoxContainer/HBoxContainer/RichTextLabel

var original_dialogo: String = ""

func _ready() -> void:

	hide()

	# Configuração do texto
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.fit_content = false
	label.scroll_active = false

	# FORÇA TAMANHO VISÍVEL
	label.custom_minimum_size = Vector2(400, 150)

	# Faz expandir corretamente
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_EXPAND_FILL

	# Caixa principal
	custom_minimum_size = Vector2(650, 320)

func start_dialogue(data: Dictionary):

	for child in escolhas.get_children():
		child.queue_free()

	original_dialogo = data["texto"]

	show()

	# Espera o layout montar
	await get_tree().process_frame

	label.text = original_dialogo

	for opcao_data in data["opcoes"]:

		var new_button := Button.new()

		new_button.text = opcao_data["texto"]

		new_button.pressed.connect(
			_on_opcao_escolhida.bind(
				opcao_data["resposta_vizinho"],
				new_button
			)
		)

		escolhas.add_child(new_button)

	var fechar_button := Button.new()

	fechar_button.text = "Encerrar Análise"

	fechar_button.pressed.connect(_on_timer_dialogo_timeout)

	escolhas.add_child(fechar_button)

func _on_opcao_escolhida(
	resposta_vizinho: String,
	button_node: Button
):

	label.text = (
		original_dialogo
		+ "\n\n> "
		+ button_node.text
		+ "\n\n"
		+ resposta_vizinho
	)

	button_node.disabled = true

func mostrar_dialogo(texto_resposta: String):

	for child in escolhas.get_children():
		child.queue_free()

	show()

	await get_tree().process_frame

	label.text = texto_resposta

	var fechar_button := Button.new()

	fechar_button.text = "Entendido"

	fechar_button.pressed.connect(_on_timer_dialogo_timeout)

	escolhas.add_child(fechar_button)

func _on_timer_dialogo_timeout() -> void:

	hide()

	original_dialogo = ""

	label.text = ""

	emit_signal("dialogo_encerrado")
