Class {
	#name : #SgEntidadFormView,
	#superclass : #WAComponent,
	#instVars : [
		'entidad',
		'mensajes',
		'tuplaModificaciones'
	],
	#category : #'Npct-Signo-Core'
}

{ #category : #'instance creation' }
SgEntidadFormView class >> for: unaEntidad [

	^ (self new)
		inicializaCon: unaEntidad
]

{ #category : #'as yet unclassified' }
SgEntidadFormView >> entidad [ 
	
	^ entidad
]

{ #category : #'as yet unclassified' }
SgEntidadFormView >> inicializaCon: unaEntidad [

	entidad := unaEntidad copy.
	mensajes := OrderedCollection new.
	tuplaModificaciones := SgTuplaEntidades from: entidad.
]

{ #category : #validating }
SgEntidadFormView >> modificarYRetornar [
	(tuplaModificaciones getAdheridaPagoPorTransferencia)
		ifFalse: [ 
			tuplaModificaciones setCuentaPagoPorTransferencia: ''.
			tuplaModificaciones setSwiftBicPagoPorTransferencia: ''.
			tuplaModificaciones setCuotaPagoPorTransferencia: 0 ].
	self validarDatos: tuplaModificaciones.
	mensajes isEmpty
		ifFalse: [ ^ self ].
	SgTablaEntidades actualizaEntidad: tuplaModificaciones.
	self answer: 'tupla-modificada'
]

{ #category : #rendering }
SgEntidadFormView >> renderBotonModificarOn: html [ 

	html tbsContainer: [ 
		html tbsButton 
			tbsPullRight ;
			bePrimary ;
			callback: [ self modificarYRetornar ] ;
			value: 'Modificar'
		 ]
]

{ #category : #rendering }
SgEntidadFormView >> renderCapturaAdhesionPagoTransferenciaOn: html [ 
	
	html tbsFormGroup: [ 
		html checkbox  
			id: 'adhesion-pago-transferencia';
			value: self entidad adheridaPagoTransferencia;
			callback: [ :aBoolean | tuplaModificaciones setAdheridaAPagoPorTransferencia: aBoolean ];
			onChange: (html jQuery id: 'datos-pago-transferencia') toggle .
		html text: ' Adherida a pago por transferencia'.
		 ]
]

{ #category : #rendering }
SgEntidadFormView >> renderCapturaDescripcionOn: html [ 

	html tbsFormGroup: [ 
		html label for: 'descripcion'; with: 'Descripción'.
		html textInput tbsFormControl 
			id: 'descripcion';
			value: (self entidad descripcion);
			callback: [ :aString | tuplaModificaciones setDescripcion: aString ]
		 ]
]

{ #category : #rendering }
SgEntidadFormView >> renderCapturaUrlConsultaEstadoOn: html [ 

	html tbsFormGroup: [ 
		html label for: 'url-consulta-estado'; with: 'Url consulta estado'.
		html textInput tbsFormControl 
			id: 'url-consulta-estado';
			value: (self entidad urlConsultaEstado );
			callback: [ :unaUrl | tuplaModificaciones setUrlConsultaEstado: unaUrl ]
		 ]
]

{ #category : #rendering }
SgEntidadFormView >> renderContentOn: html [ 
	
	html document addLoadScript: (html jQuery id: 'descripcion') triggerSelect.
	
	html heading level: 2; with: 'Modificación datos entidad (', self entidad codigo, ')'.
	
	mensajes ifNotEmpty: [ self renderMensajesOn: html. mensajes removeAll ].
	
	html form: [ 
		html tbsContainer: [ 
			"self renderCapturaCodigoOn: html."
			self renderCapturaDescripcionOn: html .
			self renderCapturaUrlConsultaEstadoOn: html .
			self renderCapturaAdhesionPagoTransferenciaOn: html .
			(tuplaModificaciones getAdheridaPagoPorTransferencia)
				ifTrue: [ 
					html tbsContainer id: 'datos-pago-transferencia'; with: [ 
						self renderIBANOn: html .
						self renderSwiftBicOn: html .
						self renderCuotaOn: html
						 ]
					 ] .
			self renderNifsAutorizadosOn: html .
			self renderBotonModificarOn: html
			]
		 ]
]

{ #category : #rendering }
SgEntidadFormView >> renderCuotaOn: html [

	html tbsFormGroup: [ 
		html label for: 'cuota'; with: 'Cuota' .
		html textInput tbsFormControl 
			id: 'cuota';
			value: (self entidad cuotaPagoTransferencia );
			callback: [ :unaCuota | tuplaModificaciones setCuotaPagoPorTransferencia: unaCuota ]
		 ]
]

{ #category : #rendering }
SgEntidadFormView >> renderIBANOn: html [ 
	
	html tbsFormGroup: [ 
		html label for: 'iban'; with: 'IBAN' .
		html textInput tbsFormControl 
			id: 'iban';
			value: (self entidad cuentaPagoTransferencia );
			callback: [ :unIBAN | tuplaModificaciones setCuentaPagoPorTransferencia: unIBAN ]
		 ]
]

{ #category : #rendering }
SgEntidadFormView >> renderMensajesOn: html [
	
	html tbsContainer: [ 
		html tbsAlert
		beWarning;
		with: [ html text: 'Corrija los siguientes errores:'.
			html unorderedList
				style: 'list-style-none';
				with: [ mensajes do: [ :each |  html listItem: each ] ] ] ]
]

{ #category : #rendering }
SgEntidadFormView >> renderNifsAutorizadosOn: html [ 
	
	html tbsFormGroup: [ 
		html label for: 'nifs-autorizados'; with: 'Nifs autorizados' .
		html textInput tbsFormControl 
			id: 'nifs-autorizados';
			value: (self entidad nifsAutorizados );
			callback: [ :listaNifs | tuplaModificaciones setNifsAutorizados: listaNifs ] .
		html small: 'Introduzca una lista de NIFs separados por comas'
		 ]
]

{ #category : #rendering }
SgEntidadFormView >> renderSwiftBicOn: html [ 
	
	html tbsFormGroup: [ 
		html label for: 'swift-bic'; with: 'Swift/Bic' .
		html textInput tbsFormControl 
			id: 'swift-bic';
			value: (self entidad swiftBicPagoTransferencia );
			callback: [ :unSwiftBic | tuplaModificaciones setSwiftBicPagoPorTransferencia: unSwiftBic ]
		 ]
]

{ #category : #'as yet unclassified' }
SgEntidadFormView >> validarDatos: unaTuplaDeEntidad [

	| autorizados |
	(unaTuplaDeEntidad getDescripcion)
		ifEmpty: [ mensajes add: 'La descripción no puede estar sin contenido. ' ].
		
	autorizados := unaTuplaDeEntidad getNifsAutorizados .		
	autorizados ifNotEmpty: [ 
		('(\w{9}.?)+' asRegex matches: autorizados)
			ifFalse: [ mensajes add: 'Formato de los nifs autorizados incorrecto. ' ]
			ifTrue: [ | nifs | 
				nifs := '\W' asRegex copy: autorizados translatingMatchesUsing: [ :match | '|' ].
				unaTuplaDeEntidad setNifsAutorizados: nifs ] ].
		
	^ mensajes isEmpty
]
