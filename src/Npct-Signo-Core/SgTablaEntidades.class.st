Class {
	#name : #SgTablaEntidades,
	#superclass : #Object,
	#category : #'Npct-Signo-Core'
}

{ #category : #'as yet unclassified' }
SgTablaEntidades class >> actualizaEntidad: unaTupla [

	| client sql |
	
	client := P3Client new url: 'psql://ratodalua:rat0da.ua@localhost/pgonzalez'.
	sql := client prepare: 'UPDATE signo.eecc SET descripcion = $2, estado = $3, fecha_alta = $4, fecha_baja = $5',
	' ,url_consulta_estado = $6, adherida_pago_transferencia = $7',
	' ,cuenta_pago_transferencia = $8, swift_bic_pago_transferencia = $9, cuota_pago_transferencia = $10, nifs_autorizados = $11',
	' WHERE codigo = $1'.
	sql execute: unaTupla tupla.
	client close.
]

{ #category : #'as yet unclassified' }
SgTablaEntidades class >> eliminarEntidad: unaEntidad [

	| client sql |
	
	client := P3Client new url: 'psql://ratodalua:rat0da.ua@localhost/pgonzalez'.
	sql := client prepare: 'DELETE FROM signo.eecc WHERE codigo = $1'.
	sql execute: { unaEntidad codigo }.
	client close.
]

{ #category : #'as yet unclassified' }
SgTablaEntidades class >> entidades [

	| client sql result listaEntidades |
	
	client := P3Client new url: 'psql://ratodalua:rat0da.ua@localhost/pgonzalez'.
	sql := 'SELECT codigo, descripcion, estado, fecha_alta, fecha_baja, url_consulta_estado, ',
		'adherida_pago_transferencia, cuenta_pago_transferencia, swift_bic_pago_transferencia, ',
		'cuota_pago_transferencia, nifs_autorizados ',
		'FROM signo.eecc ORDER BY fecha_alta DESC'.
	result := client query: sql.
	listaEntidades := result data collect: [ :each | SgEntidad from: each ].
	client close.
	^ listaEntidades
]

{ #category : #'as yet unclassified' }
SgTablaEntidades class >> insertarEntidad: unaTupla [

	| client sql |
	
	client := P3Client new url: 'psql://ratodalua:rat0da.ua@localhost/pgonzalez'.
	sql := client prepare: 'INSERT INTO signo.eecc(codigo, descripcion, estado, fecha_alta, fecha_baja, url_consulta_estado, adherida_pago_transferencia, cuenta_pago_transferencia, swift_bic_pago_transferencia, cuota_pago_transferencia, nifs_autorizados) values($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)'.
	sql execute: unaTupla.
	client close.
]

{ #category : #'as yet unclassified' }
SgTablaEntidades class >> marcaEntidadDeAlta: unaEntidad [

	| client sql |
	
	client := P3Client new url: 'psql://ratodalua:rat0da.ua@localhost/pgonzalez'.
	sql := client prepare: 'UPDATE signo.eecc SET estado = 1, fecha_alta = current_timestamp WHERE codigo = $1'.
	sql execute: { unaEntidad codigo }.
	client close.
]

{ #category : #'as yet unclassified' }
SgTablaEntidades class >> marchaEntidadDeBaja: unaEntidad [

	| client sql |
	
	client := P3Client new url: 'psql://ratodalua:rat0da.ua@localhost/pgonzalez'.
	sql := client prepare: 'UPDATE signo.eecc SET estado = 0, fecha_baja = current_timestamp WHERE codigo = $1'.
	sql execute: { unaEntidad codigo }.
	client close.
]
