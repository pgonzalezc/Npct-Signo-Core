Class {
	#name : #SgEntidad,
	#superclass : #Object,
	#instVars : [
		'codigo',
		'descripcion',
		'estado',
		'fechaAlta',
		'fechaBaja',
		'urlConsultaEstado',
		'adheridaPagoTransferencia',
		'cuentaPagoTransferencia',
		'swiftBicPagoTransferencia',
		'cuotaPagoTransferencia',
		'nifsAutorizados'
	],
	#category : #'Npct-Signo-Core'
}

{ #category : #'instance creation' }
SgEntidad class >> from: unaTupla [

	^ (self new)
		inicializaCon: unaTupla.
]

{ #category : #accessing }
SgEntidad >> adheridaPagoTransferencia [
	^ adheridaPagoTransferencia
]

{ #category : #converting }
SgEntidad >> asTuple [

	"Devuelve un array con los atributos de una entidad como si fuese una tupla para la tabla signo.eecc"
	
	^ { self codigo . self descripcion . self estado . self fechaAlta . self fechaBaja . self urlConsultaEstado . self adheridaPagoTransferencia . self cuentaPagoTransferencia .self swiftBicPagoTransferencia . self cuotaPagoTransferencia . self nifsAutorizados  }
]

{ #category : #accessing }
SgEntidad >> codigo [
	^ codigo
]

{ #category : #accessing }
SgEntidad >> cuentaPagoTransferencia [
	^ cuentaPagoTransferencia
]

{ #category : #accessing }
SgEntidad >> cuotaPagoTransferencia [
	^ cuotaPagoTransferencia
]

{ #category : #accessing }
SgEntidad >> descripcion [
	^ descripcion
]

{ #category : #'as yet unclassified' }
SgEntidad >> estaDeAlta [

	^ 1 == estado
]

{ #category : #accessing }
SgEntidad >> estado [
	^ estado
]

{ #category : #accessing }
SgEntidad >> fechaAlta [
	^ fechaAlta
]

{ #category : #accessing }
SgEntidad >> fechaBaja [
	^ fechaBaja
]

{ #category : #'as yet unclassified' }
SgEntidad >> inicializaCon: unaTupla [

	codigo := unaTupla at: 1.
	descripcion := (unaTupla at: 2) trim.
	estado := unaTupla at: 3.
	fechaAlta := unaTupla at: 4.
	fechaBaja := unaTupla at: 5.
	urlConsultaEstado := (unaTupla at: 6) ifNotNil: [ (unaTupla at: 6) trim].
	adheridaPagoTransferencia := unaTupla at: 7.
	cuentaPagoTransferencia := (unaTupla at: 8) ifNotNil: [(unaTupla at: 8) trim].
	swiftBicPagoTransferencia := (unaTupla at: 9) ifNotNil: [(unaTupla at:9) trim].
	cuotaPagoTransferencia := unaTupla at: 10.
	nifsAutorizados := (unaTupla at: 11) trim
	
]

{ #category : #accessing }
SgEntidad >> nifsAutorizados [
	^ nifsAutorizados
]

{ #category : #printing }
SgEntidad >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPutAll: ' fechaAlta: ';
		print: fechaAlta.
	aStream
		nextPutAll: ' estado: ';
		print: estado.
	aStream
		nextPutAll: ' descripcion: ';
		print: descripcion.
	aStream
		nextPutAll: ' codigo: ';
		print: codigo
]

{ #category : #accessing }
SgEntidad >> swiftBicPagoTransferencia [
	^ swiftBicPagoTransferencia
]

{ #category : #accessing }
SgEntidad >> urlConsultaEstado [
	^ urlConsultaEstado
]
