extends CanvasLayer

signal dialogo_encerrado

@onready var escolhas: VBoxContainer = $VBoxContainer/VBoxContainer
@onready var timer_dialogo: Timer = $timer_dialogo
@onready var label: RichTextLabel = $VBoxContainer/PanelContainer/RichTextLabel

var original_dialogo: String = ""


func _ready() -> void:

	hide()

	# ===== TEXTO =====
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.fit_content = false
	label.scroll_active = false
	
	var minha_fonte = preload(
	"res://assets/PixelOperator.ttf"
)

	label.add_theme_font_override(
		"normal_font",
		minha_fonte
	)

	# ===== ESCOLHAS =====
	escolhas.size_flags_vertical = 0

	escolhas.add_theme_constant_override(
		"separation",
		2
	)
	
	label.add_theme_font_size_override(
	"normal_font_size",
	12
)


func criar_botao_estilizado(texto_botao: String) -> Button:

	var button := Button.new()

	button.text = texto_botao

	# ===== TAMANHO =====
	button.custom_minimum_size = Vector2(300, 24)

	button.size_flags_horizontal = 0
	button.size_flags_vertical = 0

	# REMOVE O QUADRADO CINZA
	button.focus_mode = Control.FOCUS_NONE

	var empty_style := StyleBoxEmpty.new()

	button.add_theme_stylebox_override(
		"focus",
		empty_style
	)

	# ===== TEXTO =====
	button.add_theme_color_override(
		"font_color",
		Color.WHITE
	)

	button.add_theme_font_size_override(
		"font_size",
		12
	)
	
	var minha_fonte = preload(
	"res://assets/PixelOperator.ttf"
)

	button.add_theme_font_override(
		"font",
		minha_fonte
	)
	
	# ===== ESTILOS =====

	var normal_style := StyleBoxTexture.new()
	normal_style.texture = preload(
		"res://assets/sprites/ESCOLHA.png"
	)

	var hover_style := StyleBoxTexture.new()
	hover_style.texture = preload(
		"res://assets/sprites/ESCOLHA_HOVER.png"
	)

	var pressed_style := StyleBoxTexture.new()
	pressed_style.texture = preload(
		"res://assets/sprites/ESCOLHA_PRESSED.png"
	)

	# ===== MARGENS =====

	for style in [
		normal_style,
		hover_style,
		pressed_style
	]:

		style.texture_margin_left = 10
		style.texture_margin_right = 10
		style.texture_margin_top = 4
		style.texture_margin_bottom = 4

	# ===== APPLY =====

	button.add_theme_stylebox_override(
		"normal",
		normal_style
	)

	button.add_theme_stylebox_override(
		"hover",
		hover_style
	)

	button.add_theme_stylebox_override(
		"pressed",
		pressed_style
	)
	
	button.add_theme_stylebox_override(
	"disabled",
	pressed_style
	)

	return button


func start_dialogue(data: Dictionary):

	for child in escolhas.get_children():
		child.queue_free()

	original_dialogo = data["texto"]

	show()

	await get_tree().process_frame

	label.text = original_dialogo

	for opcao_data in data["opcoes"]:

		var new_button := criar_botao_estilizado(
			opcao_data["texto"]
		)

		new_button.pressed.connect(
			_on_opcao_escolhida.bind(
				opcao_data["resposta_vizinho"],
				new_button
			)
		)

		escolhas.add_child(new_button)

	var fechar_button := criar_botao_estilizado(
		"Encerrar Análise"
	)

	fechar_button.pressed.connect(
		_on_timer_dialogo_timeout
	)

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

	var fechar_button := criar_botao_estilizado(
		"Entendido"
	)

	fechar_button.pressed.connect(
		_on_timer_dialogo_timeout
	)

	escolhas.add_child(fechar_button)


func _on_timer_dialogo_timeout() -> void:

	hide()

	original_dialogo = ""

	label.text = ""

	emit_signal("dialogo_encerrado")
