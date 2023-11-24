extends Node



class base:
	func _init(tipo := "", nome := "", descricao := "", custo := 1, posicao := -1):
		self.tipo = tipo
		self._nome = nome
		self._descricao = descricao
		self._custo = custo
		self._position = posicao
		
	
	func get_tipo():
		pass
	func get_nome():
		pass
	func get__descricao():
		pass
	func get_custo():
		pass
	func get_position():
		pass
	func set_position():
		pass


class vida:
	func _init(vida := 0):
		self._vida = vida
		self._vida_p = 0
		
	func get_vida():
		return self._vida - self._vida_p
	func get_vidainicial():
		return self._vida
	func curaoudano(A:int):
		self._vida_p += A
		if self._vida < self._vida_p:
			self._vida_p += 0


class carta(base(),vida()):
	func _init():
		pass

