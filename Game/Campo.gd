extends Node

var baralho_jogador_1 = [[],[]]
var baralho_jogador_2 = [[],[]]
var mao_jogador_1 = []
var mao_jogador_2 = []
var campo_jogador_1 = [[],[]]
var campo_jogador_2 = [[],[]]
var Cemiterio_jogador_1 = []
var Cemiterio_jogador_2 = []

# Called when the node enters the scene tree for the first time.
func _ready():
	print("campo entrou")
	print(mao_jogador_1,"\n",campo_jogador_1)


# cria uma carta
func popular(jogador:int):
	print("populando jogador", jogador)
	if jogador == 1:
		pass
	elif jogador == 2:
		pass

func move_carta(de,para):
	print("movendo carta")
	pass


func _on_button_pressed():
	popular(1)
