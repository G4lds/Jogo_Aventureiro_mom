
extends Node2D

var is_selected : bool = false

func _ready():
	pass  # Inicialização

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		toggle_selection()

func toggle_selection():
	is_selected = !is_selected
	if is_selected:
		# ação da carta selecionada
		self.modulate = Color(1, 1, 0.5)  # Carta fica amarela quando selecionada
	else:
		# carta descartada
		self.modulate = Color(1, 1, 1)  # tom branco

@export var baralho_1 = [
	["Nome", "Descricao", "Classe", "Raca", [10,20,30], [10,20,30], [10,20,30], [10,20,30], [10,20,30], [10,20,30]],
	["Nome", "Descricao", "Classe", "Raca", [10,20,30], [10,20,30], [10,20,30], [10,20,30], [10,20,30], [10,20,30]],
	["Nome", "Descricao", "Classe", "Raca", [10,20,30], [10,20,30], [10,20,30], [10,20,30], [10,20,30], [10,20,30]],
	["Nome", "Descricao", "Classe", "Raca", [10,20,30], [10,20,30], [10,20,30], [10,20,30], [10,20,30], [10,20,30]],
	["Nome", "Descricao", "Classe", "Raca", [10,20,30], [10,20,30], [10,20,30], [10,20,30], [10,20,30], [10,20,30]]
]
