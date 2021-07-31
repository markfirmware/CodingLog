Class {
	#name : #GhNode,
	#superclass : #Object,
	#instVars : [
		'data'
	],
	#category : #CodingLog
}

{ #category : #accessing }
GhNode class >> user [
	^ self new data: (GhSession user)
]

{ #category : #accessing }
GhNode >> arrayView: aView [
	^ aView list
		items: data
]

{ #category : #accessing }
GhNode >> data: someData [
	data := someData isArray ifTrue: [
		(someData collect: [ :each |
			GhNode new data: each
		]) sorted: [ :a :b | a titleString asLowercase < b titleString asLowercase ]
	] ifFalse: [
		someData
	]
]

{ #category : #accessing }
GhNode >> dataFor: aView [
	<gtView>
	^ (data isArray ifTrue: [
		self arrayView: aView
	] ifFalse: [
		self dictionaryView: aView
	])
		title: 'Data';
		send: [ :each | self send: each value ]
]

{ #category : #accessing }
GhNode >> dictionaryView: aView [
	^ aView columnedList
		items: [
			data associations sorted: [ :a :b |
				a key < b key
			]
		];
		column: 'Key' text: [ :each | each key ];
		column: 'Value' text: [ :each | each value ]
]

{ #category : #accessing }
GhNode >> gtActionWebBrowseFor: anAction [
	<gtAction>
	data isDictionary ifTrue: [
		data at: #html_url ifPresent: [ :htmlUrl |
			^ anAction explicit stencil: [
				BrButton new
					aptitude: BrGlamorousButtonWithIconAptitude;
					action:  [ WebBrowser openOn: htmlUrl ];
					icon: BrGlamorousIcons go asElement;
					label: 'Open in OS' translated
			]
		]
	].
	^ anAction
]

{ #category : #accessing }
GhNode >> gtDismissNotificationActionFor: anAction [
	<gtAction>
	data isDictionary ifTrue: [
		(data at: #unread ifAbsent: [ false ]) ifTrue: [
			^ anAction button
				icon: BrGlamorousIcons cancel;
				tooltip: 'Mark as read';
				priority: 1;
				action: [ :aButton | GhSession patch: (data at: #url) ]
		]
	].
	^ anAction
]

{ #category : #accessing }
GhNode >> gtDisplayOn: stream [
	stream nextPutAll: self titleString
]

{ #category : #accessing }
GhNode >> send: each [ 
	(each isString and: [ each beginsWith: GhSession apiPrefix]) ifTrue: [
		^ GhNode new data: (GhSession get: (self trimUrl: each))
	].
	(each isArray or: [each isDictionary]) ifTrue: [
		^GhNode new data: each
	].
	^ each
]

{ #category : #accessing }
GhNode >> titleString [
	^ data isDictionary ifTrue: [
		self titleStringFor: data
	] ifFalse: [
		'list'
	]
]

{ #category : #accessing }
GhNode >> titleStringFor: d [
	| s |
	s := d at: #name ifAbsent: [ nil ].
	s := s ifNil: [ d at: #login ifAbsent: [ nil ] ].
	s := s ifNil: [ d at: #title ifAbsent: [ nil ] ].
	s := s ifNil: [ d at: #name ifAbsent: [ nil ] ].
	s := s ifNil: [ d at: #body ifAbsent: [ nil ] ].
	s := s ifNil: [ d at: #message ifAbsent: [ nil ] ].
	s := s ifNil: [ d at: #subject ifPresent: [ :d2 | self titleStringFor: d2 ] ].
	s := s ifNil: [ d at: #payload ifPresent: [ :d2 | self titleStringFor: d2 ] ].
	s := s ifNil: [ d at: #issue ifPresent: [ :d2 | self titleStringFor: d2 ] ].
	s := s ifNil: [ d at: #pull_request ifPresent: [ :d2 | self titleStringFor: d2 ] ].
	s := s ifNil: [ d at: #commits ifPresent: [ :commits | commits size printString , ' commits' ] ].
	s := s ifNil: [ 'something' ].
	^ s
]

{ #category : #accessing }
GhNode >> trimUrl: url [
	| index |
	index := url findString: '{'.
	^ index = 0 ifTrue: [ url ] ifFalse: [ url copyFrom: 1 to: index - 1 ]
]
