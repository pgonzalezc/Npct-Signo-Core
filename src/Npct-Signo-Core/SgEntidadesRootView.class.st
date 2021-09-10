Class {
	#name : #SgEntidadesRootView,
	#superclass : #WAComponent,
	#instVars : [
		'entidad'
	],
	#category : #'Npct-Signo-Core'
}

{ #category : #testing }
SgEntidadesRootView class >> canBeRoot [ 
	
	 ^ true
]

{ #category : #'class initialization' }
SgEntidadesRootView class >> initialize [ 

	" self initialize "
	| app |
	
	app := WAAdmin register: self asApplicationAt: 'Entidades'.
	app 
		addLibrary: JQDeploymentLibrary;
		addLibrary: JQUiDeploymentLibrary;
		addLibrary: TBSDeploymentLibrary.
]

{ #category : #converting }
SgEntidadesRootView >> asStandardFormat: aDateTime [
	aDateTime
		ifNotNil: [ ^ String
				streamContents: [ :aStream | 
					aDateTime printYMDOn: aStream.
					aStream nextPutAll: ' '.
					aDateTime printHMSOn: aStream ] ]
		ifNil: [ ^ '' ]
]

{ #category : #'as yet unclassified' }
SgEntidadesRootView >> darDeAltaEntidad: unaEntidad [

	SgTablaEntidades marcaEntidadDeAlta: unaEntidad
]

{ #category : #'as yet unclassified' }
SgEntidadesRootView >> darDeBajaEntidad: unaEntidad [

	SgTablaEntidades marchaEntidadDeBaja: unaEntidad.
]

{ #category : #'as yet unclassified' }
SgEntidadesRootView >> eliminarEntidad: unaEntidad [

	SgTablaEntidades eliminarEntidad: unaEntidad
]

{ #category : #'as yet unclassified' }
SgEntidadesRootView >> irAModificarEntidad: unaEntidad [

	self call: (SgEntidadFormView for: unaEntidad)
]

{ #category : #'as yet unclassified' }
SgEntidadesRootView >> irNuevaEntidadView [

	self call: SgNuevaEntidadView new
]

{ #category : #rendering }
SgEntidadesRootView >> renderContentOn: html [ 

	"Página inicial de las consultas de las entidades".
	
	html tbsNavbar beDefault with: [ 
		html tbsContainerFluid: [
			html tbsNavbarHeader: [  
				html tbsNavbarBrand
					url: self application url;
					with: 'Entidades'
			]
		]
	].
	html tbsContainer: [ 
		html form: [ 
				html tbsButton
					tbsPullRight;
					beDefault;
					callback: [ self irNuevaEntidadView ];
					with: [ 
						html tbsGlyphIcon iconEdit.
						html space.
						html text: 'Añadir entidad'
				 ]
			]
	 ].
	html space.
	html tbsContainer: [ 
		entidad 
			ifNotNil: [ self renderDetalleEntidadOn: html ]
			ifNil: [ self renderListaEntidadesOn: html ]
		]
	
	
	
]

{ #category : #rendering }
SgEntidadesRootView >> renderDetalleEntidadOn: html [

	html tbsPanel beDefault with: [ 
			html tbsPanelHeading: [ 
				html heading level:3; with: (String streamContents: [ :stream | stream << entidad codigo << ': ' << entidad descripcion ]).
				 ].
			html tbsPanelBody: [ 
				html break.
				self renderEntidadOn: html
		 ]
	 ] 
]

{ #category : #rendering }
SgEntidadesRootView >> renderEntidadOn: html [ 

	html unorderedList
		style: 'list-style-type: none';
		with: [ 
			html listItem with: [ 
				html strong: 'codigo: '. 
				html text: entidad codigo
				].
			html listItem with: [ 
				html strong: 'descripción: '.
				html text: entidad descripcion
			 ].
			html listItem with: [ 
				html strong: 'estado: '.
				entidad estaDeAlta
					ifTrue: [ html emphasis: 'Activa'. html text: ' desde el ', (self asStandardFormat: entidad fechaAlta) ]
					ifFalse: [ html emphasis: 'Inactiva'. html text: ' desde el ', (self asStandardFormat: entidad fechaBaja) ]
			 ].
			html listItem with: [ 
				html strong: 'url de consulta de estado: '.
				html text: entidad urlConsultaEstado
			].
			html listItem with: [ 
				html strong: 'adherida a pago por transferencia: '.
				entidad adheridaPagoTransferencia 
					ifFalse: [ html text: 'no' ]
					ifTrue: [ 
						html text: 'si'.
						html unorderedList
							style: 'list-style-type: none';
							with: [ 
								html listItem with: [ 
									html strong: 'cuenta bancaria: '.
									html text: entidad cuentaPagoTransferencia, '/', entidad swiftBicPagoTransferencia 
									 ].
								html listItem with: [ 
									html strong: 'cuota: '.
									html text: entidad cuotaPagoTransferencia asString, '%'
									 ]
								 ]
						 ]
			].
			html listItem: [ 
				html strong: 'nifs autorizados: '.
				html text: entidad nifsAutorizados 
				 ]
			
		]
		
]

{ #category : #rendering }
SgEntidadesRootView >> renderListaEntidadesOn: html [ 

	
	html tbsTable beStriped; with: [ 
		html tableHead: [ 
			html tableHeading: 'Entidad'.
			html tableHeading: 'Código'.
			html tableHeading: 'Estado'.
			html tableHeading: 'Fecha alta'.
			html tableHeading: 'Fecha baja'.
			html tableHeading: ''
			 ].
		html tableBody: [  
			SgTablaEntidades entidades do: [ :each | 
			html tableRow id: each codigo; with: [
				html tableData: [ html anchor callback: [ self setEntidad: each ]; with: each descripcion .
				html tableData: each codigo .
				html tableData: [ 
					html text: (each estado = 1 ifTrue: [ 'Alta' ] ifFalse: [ 'Baja' ]).
					html space.
					each estado = 1 
						ifTrue: [ 
							html anchor 
								callback: [ self darDeBajaEntidad: each ];
								with: [ html tbsGlyphIcon iconBanCircle ] ]
						ifFalse: [ 
							html anchor 
								callback: [ self darDeAltaEntidad: each ];
								with: [ html tbsGlyphIcon iconCheck ]
							 ]
					 ].
				html tableData: (self asStandardFormat: each fechaAlta).
				html tableData: (self asStandardFormat: each fechaBaja).
				html tableData: [ 
					html anchor callback: [ self setEntidad: each ]; with: [ html tbsGlyphIcon iconEyeOpen ].
					html space.
					html anchor callback: [ self eliminarEntidad: each ]; with: [ html tbsGlyphIcon iconTrash ].
					html space.
					html anchor callback: [ self irAModificarEntidad: each ]; with: [ html tbsGlyphIcon iconEdit ]
					] ] ] ] ] ]
]

{ #category : #initialization }
SgEntidadesRootView >> resetEntidad [

	entidad := nil
]

{ #category : #initialization }
SgEntidadesRootView >> setEntidad: unaEntidad [

	entidad := unaEntidad
]

{ #category : #updating }
SgEntidadesRootView >> updateRoot: anHtmlRoot [

	super updateRoot: anHtmlRoot.
	anHtmlRoot beHtml5.
	anHtmlRoot title: 'Entidades'
]
