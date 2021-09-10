Class {
	#name : #SgTuplaEntidades,
	#superclass : #Object,
	#instVars : [
		'tupla'
	],
	#category : #'Npct-Signo-Core'
}

{ #category : #'instance creation' }
SgTuplaEntidades class >> from: unaEntidad [

	"Convierte un objeto de la clase SgEntidad en un objeto SgTuplaEntidad"
	^ (self new)
		inicializaCon: unaEntidad 
]

{ #category : #'as yet unclassified' }
SgTuplaEntidades >> getAdheridaPagoPorTransferencia [

	^ tupla at: 7
]

{ #category : #'as yet unclassified' }
SgTuplaEntidades >> getDescripcion [

	^ tupla at: 2
]

{ #category : #'as yet unclassified' }
SgTuplaEntidades >> getNifsAutorizados [

	^ tupla at: 11
]

{ #category : #'as yet unclassified' }
SgTuplaEntidades >> inicializaCon: unaEntidad [

	tupla := { unaEntidad codigo . unaEntidad descripcion . unaEntidad estado . unaEntidad fechaAlta . unaEntidad fechaBaja . unaEntidad urlConsultaEstado . unaEntidad adheridaPagoTransferencia . unaEntidad cuentaPagoTransferencia .unaEntidad swiftBicPagoTransferencia . unaEntidad cuotaPagoTransferencia . unaEntidad nifsAutorizados  }
]

{ #category : #initialization }
SgTuplaEntidades >> setAdheridaAPagoPorTransferencia: aBoolean [

	tupla at: 7 put: aBoolean
]

{ #category : #initialization }
SgTuplaEntidades >> setCuentaPagoPorTransferencia: unIBAN [

	tupla at: 8 put: unIBAN
	
]

{ #category : #initialization }
SgTuplaEntidades >> setCuotaPagoPorTransferencia: anInteger [

	tupla at: 10 put: anInteger
]

{ #category : #initialization }
SgTuplaEntidades >> setDescripcion: unaCadena [

	tupla at: 2 put: unaCadena
]

{ #category : #initialization }
SgTuplaEntidades >> setEstado: aBoolean [

	tupla at: 3 put: aBoolean
]

{ #category : #initialization }
SgTuplaEntidades >> setFechaAlta: aDateAndTime [

	tupla at: 4 put: aDateAndTime
]

{ #category : #initialization }
SgTuplaEntidades >> setFechaBaja: aDateAndTime [

	tupla at: 5 put: aDateAndTime
]

{ #category : #initialization }
SgTuplaEntidades >> setNifsAutorizados: aString [

	tupla at: 11 put: aString
]

{ #category : #initialization }
SgTuplaEntidades >> setSwiftBicPagoPorTransferencia: unSwiftBic [

	tupla at: 9 put: unSwiftBic
]

{ #category : #initialization }
SgTuplaEntidades >> setUrlConsultaEstado: unaURL [

	tupla at: 6 put: unaURL
]

{ #category : #accessing }
SgTuplaEntidades >> tupla [
	^ tupla
]
