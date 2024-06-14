class Nave{
	var property velocidad = 0 
	var property direccion = 0
	var property cantCombustible = 0
	
	
	method acelerar(cuanto) {velocidad = (velocidad+cuanto).min(100000)}
	method desacelerar(cuanto) {velocidad = (velocidad-cuanto).max(0)}
	method irHaciaElSol() {direccion = 10}
	method escaparDelSol() {direccion = -10}
	method ponerseParaleloAlSol() {direccion = 0}
	method acercarseUnPocoAlSol() {direccion = (direccion + 1).min(10)}
	method alejarseUnPocoDelSol() {direccion = (direccion - 1).max(-10)}
	method cargarCombustible(cuanto) {cantCombustible += cuanto}
	method desCargarCombustible(cuanto) {cantCombustible = (cantCombustible - cuanto).max(0)} 
	method prepararViaje(){
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	method estaTranquila() = cantCombustible >= 4000 and velocidad <= 12000
}

class NaveBaliza inherits Nave{
	var colorBaliza = null
	var cantCambios = 0
	
	method colorActualBaliza() = colorBaliza
	method cambiarColorDeBaliza(colorNuevo) {colorBaliza = colorNuevo cantCambios += 1}
	override method prepararViaje(){
		super()
		self.cambiarColorDeBaliza("verde")
		self.ponerseParaleloAlSol()
	}
	override method estaTranquila() = super() and colorBaliza == "rojo"
	method recibirAmenaza() {
		self.irHaciaElSol()
		self.cambiarColorDeBaliza("rojo")
	}
	method estaDeRelajo() = cantCambios == 0

}

class NavePasajeros inherits Nave{
	var property cantPasajeros = 0
	var cantComida = 0
	var cantBebida = 0 
	var comidaServida = 0
	
	method c() = cantComida
	method b() = cantBebida
	method a() = comidaServida
	method agregarComida(cuanto){cantComida += cuanto}
	method servirComida(cuanto) {cantComida -= cuanto comidaServida += cuanto}
	method agregarBebida(cuanto){cantBebida += cuanto}
	method servirBebida(cuanto) {cantBebida -= cuanto}
	override method prepararViaje(){
		super()
		cantComida += 4 
		cantBebida += 6
		self.acercarseUnPocoAlSol()
	}
	method recibirAmenaza(){
		velocidad = velocidad * 2
		cantComida -= cantPasajeros
		cantBebida -= cantPasajeros * 2
	}
	method estaDeRelajo() = comidaServida < 50
}

class NaveHospital inherits NavePasajeros{
	var property quirofanosPreparados = null
	
	override method estaTranquila() = super() and not quirofanosPreparados
	override method recibirAmenaza(){
		super()
		quirofanosPreparados = true
	} 
}

class NaveCombate inherits Nave{
	var estaInvisible = null
	var misilesDesplegados = null
	const mensajesEmitidos = []

	method ponerseInvisible(){estaInvisible = true}			
	method ponerseVisible() {estaInvisible = false}
	method estaInvisible() = estaInvisible
	method desplegarMisiles() {misilesDesplegados = true}
	method replegarMisiles(){misilesDesplegados = false}
	method misilesDesplegados() = misilesDesplegados
	method emitirMensaje(mensaje){mensajesEmitidos.add(mensaje)}
	method mensajesEmitidos() = mensajesEmitidos
	method primerMensajeEmitido() = mensajesEmitidos.first()
	method ultimoMensajeEmitido() = mensajesEmitidos.last()
	method esEscueta() = mensajesEmitidos.any({x=>x.size() > 30})
	method emitioMensaje(mensaje) = mensajesEmitidos.any({x=>x == mensaje})
	override method prepararViaje(){
		super()
		self.desplegarMisiles()
		self.ponerseVisible()
		self.acelerar(15000)
		self.emitirMensaje("Saliendo en misión")
	}
	override method estaTranquila() = super() and not misilesDesplegados 
	method recibirAmenaza(){
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
		self.emitirMensaje("Amenaza recibida")
	}
	method estaDeRelajo() = self.esEscueta() 
}
	

class NaveCombateSigilosa inherits NaveCombate{
	
	override method estaTranquila() = super() and not estaInvisible
	override method recibirAmenaza(){
		super()
		self.desplegarMisiles()
		self.ponerseInvisible()
	} 
}