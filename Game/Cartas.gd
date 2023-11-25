extends Node

const niveis = [50, 125]

class carta_personagem:
	var _nome
	var _descricao
	var _experiencia
	var _classe
	var _raca
	var _vida
	var _ataque
	var _magia
	var _velocidade
	var _defesa_normal
	var _defesa_magica
	
	func _init(
		nome,
		descricao,
		classe,
		raca,
		vida,
		ataque,
		magia,
		velocidade,
		defesa_normal,
		defesa_magica
	):
		self._nome = nome
		self._descricao = descricao
		self._experiencia = 0
		self._classe = classe
		self._raca = raca
		self._vida = vida
		self._ataque = ataque
		self._magia = magia
		self._velocidade = velocidade
		self._defesa_normal = defesa_normal
		self._defesa_magica = defesa_magica
	
	func _nivel():
		if self._experiencia < niveis[0]:
			return 1
		if self._experiencia > niveis[1]:
			return 3
		return 2

func _ready():
	print("cartas entrou")
