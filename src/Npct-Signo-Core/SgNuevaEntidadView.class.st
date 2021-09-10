Class {
	#name : #SgNuevaEntidadView,
	#superclass : #WAComponent,
	#instVars : [
		'codigo',
		'descripcion',
		'urlConsultaEstado',
		'mensajes',
		'adheridaPagoTransferencia',
		'cuentaPagoTransferencia',
		'swiftBicPagoTransferencia',
		'cuotaPagoTransferencia',
		'nifsAutorizados'
	],
	#category : #'Npct-Signo-Core'
}

{ #category : #accessing }
SgNuevaEntidadView >> adheridaPagoTransferencia [
	^ adheridaPagoTransferencia
]

{ #category : #accessing }
SgNuevaEntidadView >> adheridaPagoTransferencia: anObject [
	adheridaPagoTransferencia := anObject
]

{ #category : #accessing }
SgNuevaEntidadView >> codigo [
	^ codigo
]

{ #category : #accessing }
SgNuevaEntidadView >> codigo: anObject [
	codigo := anObject
]

{ #category : #'as yet unclassified' }
SgNuevaEntidadView >> conmutarAdhesionPagoTransferencia [

	adheridaPagoTransferencia := adheridaPagoTransferencia not
]

{ #category : #accessing }
SgNuevaEntidadView >> cuentaPagoTransferencia [
	^ cuentaPagoTransferencia
]

{ #category : #accessing }
SgNuevaEntidadView >> cuentaPagoTransferencia: anObject [

	cuentaPagoTransferencia := anObject
]

{ #category : #accessing }
SgNuevaEntidadView >> cuotaPagoTransferencia [
	^ cuotaPagoTransferencia
]

{ #category : #accessing }
SgNuevaEntidadView >> cuotaPagoTransferencia: anObject [
	cuotaPagoTransferencia := anObject
]

{ #category : #accessing }
SgNuevaEntidadView >> descripcion [
	^ descripcion
]

{ #category : #accessing }
SgNuevaEntidadView >> descripcion: anObject [
	descripcion := anObject
]

{ #category : #'as yet unclassified' }
SgNuevaEntidadView >> grabarYRetornar [
	
	self validaCodigo: codigo.
	self validaDescripcion: descripcion.
	urlConsultaEstado trim isEmpty
		ifFalse: [ self validaUrl: urlConsultaEstado  ].
	adheridaPagoTransferencia ifTrue: [ 
		self validaCuentaPagoTransferencia: cuentaPagoTransferencia.
		self validaSwiftBicPagoTransferencia: swiftBicPagoTransferencia.
		self validaCuotaPagoTransferencia: cuotaPagoTransferencia 
		 ].
		
	SgTablaEntidades insertarEntidad: { codigo . descripcion . 1 . DateAndTime now . nil . urlConsultaEstado . adheridaPagoTransferencia  . cuentaPagoTransferencia  . swiftBicPagoTransferencia  . cuotaPagoTransferencia  . '' }.
	
	mensajes isEmpty ifTrue: [ self answer: 'correcto - dado de alta']
]

{ #category : #initialization }
SgNuevaEntidadView >> initialize [ 

	super initialize.
	mensajes := OrderedCollection new.
	codigo := ''.
	descripcion := ''.
	urlConsultaEstado := ''.
	adheridaPagoTransferencia := false.
	cuentaPagoTransferencia := ''.
	swiftBicPagoTransferencia := ''.
	cuotaPagoTransferencia := 0.
	nifsAutorizados := OrderedCollection new
	
]

{ #category : #accessing }
SgNuevaEntidadView >> mensajes [
	^ mensajes
]

{ #category : #rendering }
SgNuevaEntidadView >> renderBotonGrabarOn: html [

	html tbsContainer: [ html tbsButton
		tbsPullRight;
		bePrimary;
		callback: [ self grabarYRetornar ];
		value: 'Grabar' ]
]

{ #category : #rendering }
SgNuevaEntidadView >> renderCaptionCuentaPagoTransferenciaOn: html [ 

	html tbsFormGroup: [ 
		html label for: 'cuenta-corriente'; with: 'Cuenta Corriente'.
		html textInput tbsFormControl;
			id: 'cuenta-corriente';
			placeholder: 'Introduzca un IBAN para el pago por transferencia';
			value: self cuentaPagoTransferencia;
			callback: [ :unaCadena | self cuentaPagoTransferencia: unaCadena ]
	 ].
]

{ #category : #rendering }
SgNuevaEntidadView >> renderCaptionCuotaOn: html [

	html tbsFormGroup: [ 
		html label for: 'cuota'; with: 'Cuota'.
		html textInput tbsFormControl;
			id: 'cuota';
			placeholder: 'Introduzca una cuota de participación en el pago por transferencia';
			value: self cuotaPagoTransferencia ;
			callback: [ :unaCadena | self cuotaPagoTransferencia: unaCadena ]
	 ].
]

{ #category : #rendering }
SgNuevaEntidadView >> renderCaptionSwiftBicPagoPorTransferenciaOn: html [ 

	html tbsFormGroup: [ 
		html label for: 'swift-bic'; with: 'Swift-bic'.
		html textInput tbsFormControl;
			id: 'swift-bic';
			placeholder: 'Introduzca un Swift/Bic';
			value: self swiftBicPagoTransferencia ;
			callback: [ :unaCadena | self swiftBicPagoTransferencia: unaCadena ]
	 ].
]

{ #category : #rendering }
SgNuevaEntidadView >> renderCapturaAdheridaAPagoTransferenciaOn: html [

	html checkbox 
		id: 'adherida-pago-transferencia';
		value: (self adheridaPagoTransferencia);
		onChange: 
			(html jQuery ajax callback: [ :unBoolean | self conmutarAdhesionPagoTransferencia ] value: (html jQuery id: 'adherida-pago-transferencia') value;
			script: [ :s | 
				adheridaPagoTransferencia 
					ifTrue: [ s << (html jQuery id: 'datos-pago-transferencia') show ]
					ifFalse: [ s << (html jQuery id: 'datos-pago-transferencia') hide ]
				 ]).
	html text: ' ¿Adherida a Pago Por Transferencia?'.
	html tbsContainer 
		id: 'datos-pago-transferencia';
		style: 'display: none';
		with: [ 
			self renderCaptionCuentaPagoTransferenciaOn: html.
			self renderCaptionSwiftBicPagoPorTransferenciaOn: html.
			self renderCaptionCuotaOn: html.
			 ]
]

{ #category : #rendering }
SgNuevaEntidadView >> renderCapturaCodigoOn: html [

	html tbsFormGroup: [ 
	html label for: 'codigo'; with: 'Código'.
	html textInput tbsFormControl; 
		id: 'codigo'; 
		placeholder: 'Introduzca el código de la entidad';
		maxLength: 4;
		" mecanismo para realizar una llamada ajax y ejecutar javascript en el cliente
		onChange: (html jQuery ajax callback: [ :unCodigo | 
			self validarCodigo: unCodigo
		] value: (html jQuery id: 'codigo') value;
		  script: [ :s | 
				s << (s jQuery id: 'errores') html: [ :h | self renderMensajesOn: html ].
				s << (s jQuery id: 'errores') show.
				s << (s jQuery id: 'codigo') triggerSelect
			]);
		"
		value: self codigo;
		callback: [ :unCodigo | self codigo: unCodigo ]
	 ].
]

{ #category : #rendering }
SgNuevaEntidadView >> renderCapturaDescripcionOn: html [

	html tbsFormGroup: [ 
		html label for: 'descripcion'; with: 'Descripción'.
		html textInput tbsFormControl;
			id: 'descripcion';
			placeholder: 'Introduzca una descripción de la entidad';
			value: self descripcion;
			callback: [ :unaCadena | self descripcion: unaCadena ]
	 ].
]

{ #category : #rendering }
SgNuevaEntidadView >> renderCapturaUrlConsultaEstadoOn: html [

	html tbsFormGroup: [ 
	html label for: 'url-consulta-estado'; with: 'URL consulta estado'.
	html textInput tbsFormControl;
		id: 'url-consulta-estado';
		placeholder: 'URL del servicio de consulta de estado';
		value: self urlConsultaEstado ;
		callback: [ :unaURL | self urlConsultaEstado: unaURL ]
	 ].
]

{ #category : #rendering }
SgNuevaEntidadView >> renderContentOn: html [ 

	html document addLoadScript: (html jQuery id: 'codigo') triggerSelect .

	html heading level: 2; with: 'Nueva entidad'.
	mensajes isEmpty ifFalse: [ self renderMensajesOn: html. mensajes removeAll ].
	
	html tbsContainer: [ 
		html form: [ 
			self renderCapturaCodigoOn: html.
			self renderCapturaDescripcionOn: html.
			self renderCapturaUrlConsultaEstadoOn: html.
			self renderCapturaAdheridaAPagoTransferenciaOn: html.
			self renderBotonGrabarOn: html
		 	]
	 	]  
]

{ #category : #rendering }
SgNuevaEntidadView >> renderMensajesOn: html [
	
	html tbsContainer: [ 
		html tbsAlert
		beWarning;
		with: [ html text: 'Corrija los siguientes errores:'.
			html unorderedList
				style: 'list-style-none';
				with: [ mensajes do: [ :each |  html listItem: each ] ] ] ]
	
]

{ #category : #accessing }
SgNuevaEntidadView >> swiftBicPagoTransferencia [
	^ swiftBicPagoTransferencia
]

{ #category : #accessing }
SgNuevaEntidadView >> swiftBicPagoTransferencia: anObject [
	swiftBicPagoTransferencia := anObject
]

{ #category : #accessing }
SgNuevaEntidadView >> urlConsultaEstado [
	^ urlConsultaEstado
]

{ #category : #accessing }
SgNuevaEntidadView >> urlConsultaEstado: anObject [
	urlConsultaEstado := anObject
]

{ #category : #'as yet unclassified' }
SgNuevaEntidadView >> validaCodigo: unCodigo [

	('^\d{4}$' asRegex matches: unCodigo)
		ifFalse: [ mensajes add: 'Código incorrecto. Debe contener sólo caracteres numéricos' ]
]

{ #category : #'as yet unclassified' }
SgNuevaEntidadView >> validaCuentaPagoTransferencia: unaCuenta [

	
]

{ #category : #'as yet unclassified' }
SgNuevaEntidadView >> validaCuotaPagoTransferencia: aInteger [

	| entidadesAdheridas totalCuota |

	entidadesAdheridas := SgTablaEntidades entidades select: [ :each | each cuotaPagoTransferencia ~= 0 ].
	totalCuota := entidadesAdheridas inject: 0 into: [ :total :entidad | total + entidad cuotaPagoTransferencia ].
	totalCuota > 100
		ifTrue: [ mensajes add: 'La cuota de las entidades adheridas supera el 100%' ]
	
]

{ #category : #'as yet unclassified' }
SgNuevaEntidadView >> validaDescripcion: unaCadena [

	unaCadena trim isEmpty ifTrue: [ mensajes add: 'Descripcion incorrecta. Debe tener contenido' ]
]

{ #category : #'as yet unclassified' }
SgNuevaEntidadView >> validaSwiftBicPagoTransferencia: unSwiftBic [
]

{ #category : #'as yet unclassified' }
SgNuevaEntidadView >> validaUrl: unaURL [

	
]
