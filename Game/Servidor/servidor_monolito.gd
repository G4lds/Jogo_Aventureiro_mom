extends Node2D


const niveis = [50, 125]
const campo = [4,2]
const mao = 5

var baralho = [[
	["personagem", "Deirdre de Paor" , "ladrao", "humano", [20,35,50], [10,20,30], [10,20,30], [10,20,30], [10,20,30], [10,20,30],"Pessimista por Natureza, desde muito jovem teve que roubar para poder ter o que comer. Ele não é muito fã de conflitos, por isso costuma trabalhar de forma ágil e sorrateira."],
	["personagem", "Alianna Armstrong" , "ladrao", "humano", [20,35,50], [10,20,30], [10,20,30], [10,20,30], [10,20,30], [10,20,30],"Descricao"],
	["personagem", "Elrohir" , "ladrao", "humano", [20,35,50], [10,20,30], [10,20,30], [10,20,30], [10,20,30], [10,20,30],"Descricao"],
	["personagem", "Ireti" , "ladrao", "humano", [20,35,50], [10,20,30], [10,20,30], [10,20,30], [10,20,30], [10,20,30],"Descricao"]
	],[]]

var jogador1_baralho = []
var Jogador1_campo = []
var jogador1_mao = []
var jogador2_baralho = []
var Jogador2_campo = []
var jogador2_mao = []


class carta_personagem:
	var _tipo
	var _nome
	var _experiencia
	var _classe
	var _raca
	var _vida
	var _ataque
	var _magia
	var _velocidade
	var _defesa_normal
	var _defesa_magica
	var _descricao
	
	func _init(
		tipo,
		nome,
		classe,
		raca,
		vida,
		ataque,
		magia,
		velocidade,
		defesa_normal,
		defesa_magica,
		descricao
	):
		self._tipo = tipo
		self._nome = nome
		self._experiencia = 0
		self._classe = classe
		self._raca = raca
		self._vida = vida
		self._ataque = ataque
		self._magia = magia
		self._velocidade = velocidade
		self._defesa_normal = defesa_normal
		self._defesa_magica = defesa_magica
		self._descricao = descricao
	
	func _nivel():
		if self._experiencia < niveis[0]:
			return 1
		if self._experiencia > niveis[1]:
			return 3
		return 2
	
	func tipo():
		return self._tipo
	func nome():
		return self._nome






func importar_baralho(id:int,jogador:int):
	if jogador == 1:
		for elm in baralho[id]:
			jogador1_baralho.append(carta_personagem.new(elm[0],elm[1],elm[2],elm[3],elm[4],elm[5],elm[6],elm[7],elm[8],elm[9],elm[10]))
	if jogador == 2:
		for elm in baralho[id]:
			jogador2_baralho.append(carta_personagem.new(elm[0],elm[1],elm[2],elm[3],elm[4],elm[5],elm[6],elm[7],elm[8],elm[9],elm[10]))

func move_carta(de,para):
	var carta = Object
	if de[0] == 1:
		if de[1] == 0:
			if (Jogador1_campo[de[2]] <= campo[0] * campo[1]) and (Jogador1_campo[de[2]] == false):
				carta = Jogador1_campo[de[2]]
			elif (jogador1_mao[de[2]] <= mao) and (jogador1_mao[de[2]] == false):
				carta = jogador1_mao[de[2]]
		elif de[1] == 1:
			if (Jogador2_campo[de[2]] <= campo[0] * campo[1]) and (Jogador2_campo[de[2]] == false):
				carta = Jogador2_campo[de[2]]
				Jogador2_campo[de[2]] = false
			elif (jogador1_mao[de[2]] <= mao) and (jogador2_mao[de[2]] == false):
				carta = jogador2_mao[de[2]]
				jogador2_mao[de[2]] = false
			

# Called when the node enters the scene tree for the first time.
func _ready():
	print("teste")
	importar_baralho(0,1)
	for elm in jogador1_baralho:
		print(elm.nome())
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
