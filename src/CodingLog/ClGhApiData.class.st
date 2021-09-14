Class {
	#name : #ClGhApiData,
	#superclass : #Object,
	#instVars : [
		'data'
	],
	#classVars : [
		'cache',
		'token'
	],
	#category : #'CodingLog-GitHub'
}

{ #category : #accessing }
ClGhApiData class >> apiPrefix [
	^ 'https://api.github.com/'
]

{ #category : #accessing }
ClGhApiData class >> cache [
	^ cache
]

{ #category : #accessing }
ClGhApiData class >> client [
	| client |
	client := ZnClient new
		accept: 'application/vnd.github.v3+json,application/vnd.github.baptiste-preview+json'.
	self token ifNotNil: [
		client headerAt: 'Authorization' put: 'token ' , self token
	].
	^ client
]

{ #category : #accessing }
ClGhApiData class >> defaultPageSize [
	^ 30
]

{ #category : #accessing }
ClGhApiData class >> fullUrl: path [
	^ (path beginsWith: self apiPrefix) ifTrue: [path] ifFalse: [self apiPrefix , path]
]

{ #category : #accessing }
ClGhApiData class >> get: path [
	| url |
	url := self fullUrl: path.
	^ self cache at: url ifAbsentPut: [
		self client
			get: url
			onSuccess: [ :result | 
				[ | ston |
					ston := STON fromString: result.
					ston isArray ifTrue: [
						ston size < self defaultPageSize ifTrue: [
							ston
						] ifFalse: [
							self items: url
						]
					] ifFalse: [
						(((ston size = 3
							and: [ ston includesKey: #total_count ])
							and: [ ston includesKey: #items ])
							and: [ ston includesKey: #incomplete_results ]) ifTrue: [ | items |
							items := ston at: #items.
							items size = (ston at: #total_count) ifTrue: [
								items
							] ifFalse: [
								self items: url
							]
						] ifFalse: [
							ston
						]
					]
				] on: Error do: [ :e | Dictionary new ] ]
			onError: [ Dictionary new ]
	]
]

{ #category : #accessing }
ClGhApiData class >> getArray: path [
	| url |
	url := self fullUrl: path.
	^ self cache at: url ifAbsentPut: [ self items: url ]
]

{ #category : #accessing }
ClGhApiData class >> getArray: path of: aClass sortKey: selector [ 
	^ ((self getArray: path) collect: [ :each | aClass new data: each ]) sorted: [ :a :b | (a perform: selector) > (b perform: selector) ]
]

{ #category : #accessing }
ClGhApiData class >> getDictionary: path [
	| url |
	url := self fullUrl: path.
	^ self cache at: url ifAbsentPut: [
		self client
			get: url
			onSuccess: [ :result | 
				[ 
					STON fromString: result
				] on: Error do: [ :e | Dictionary new ] ]
			onError: [ Dictionary new ]
	]
]

{ #category : #accessing }
ClGhApiData class >> getDictionary: path of: aClass [
	^ aClass new data: (self getDictionary: path)
]

{ #category : #accessing }
ClGhApiData class >> initialize [
	super initialize.
	cache := Dictionary new
]

{ #category : #accessing }
ClGhApiData class >> items: url [
	^ self items: OrderedCollection new pageNumber: 1 url: url
]

{ #category : #accessing }
ClGhApiData class >> items: items pageNumber: pageNumber url: url [
	| marker |
	marker := (url findString: '?') = 0 ifTrue: ['?'] ifFalse: ['&'].
	^ self client
		get: url, marker,  'per_page=' , self pageSize printString , '&page=', pageNumber printString
		onSuccess: [ :result | | ston more |
			[
				ston := STON fromString: result.
				ston isDictionary ifTrue: [
					items addAll: (ston at: #items).
					more := items size < (ston at: #total_count)
				] ifFalse: [
					items addAll: ston.
					more := ston size = self pageSize
				].
				more ifTrue: [
					self items: items pageNumber: pageNumber + 1 url: url
				] ifFalse: [
					items asArray
				]
			] on: Error do: [ :e | self halt. items asArray ]
		]
		onError: [ self halt. items asArray ]
]

{ #category : #accessing }
ClGhApiData class >> pageSize [
	^ 100
]

{ #category : #accessing }
ClGhApiData class >> patch: path [
	| url |
	url := (path beginsWith: self apiPrefix) ifTrue: [path] ifFalse: [self apiPrefix , path].
	^ self client
		url: url;
		patch
]

{ #category : #accessing }
ClGhApiData class >> purge [
	cache removeAll
]

{ #category : #accessing }
ClGhApiData class >> purge: path [
	| url |
	url := (path beginsWith: self apiPrefix) ifTrue: [path] ifFalse: [self apiPrefix , path].
	cache removeKey: url ifAbsent: []
]

{ #category : #accessing }
ClGhApiData class >> token [
	^ token ifNil: [ token := Smalltalk os environment at: #GITHUB_TOKEN ifAbsent: [ nil ] ]
]

{ #category : #accessing }
ClGhApiData class >> token: aToken [
	token := aToken
]

{ #category : #accessing }
ClGhApiData >> arrayView: aView [
	^ aView list
		items: data
]

{ #category : #accessing }
ClGhApiData >> body [
	^ data at: #body
]

{ #category : #accessing }
ClGhApiData >> commentsUrl [
	^ data at: #comments_url
]

{ #category : #accessing }
ClGhApiData >> data: someData [
	data := someData isArray ifTrue: [
		(someData collect: [ :each |
			ClGhApiData new data: each
		])
	] ifFalse: [
		someData
	]
]

{ #category : #accessing }
ClGhApiData >> dictionaryView: aView [
	^ aView columnedTree
		items: [ data associations sorted: [ :a :b |
				a key < b key ] ];
		children: [ :each | 
			each value isDictionary
				ifTrue: [ each value associations sorted: [ :a :b |
					a key < b key ] ]
				ifFalse: [ (each value isArray and: [ each value allSatisfy: #isDictionary ])
						ifTrue: [ each value collectWithIndex: [ :x :i | i -> x ] ]
						ifFalse: [ #() ] ] ];
		column: 'Key' text: [ :assoc | assoc key ];
		column: 'Value' text: [ :assoc | assoc value ]
]

{ #category : #accessing }
ClGhApiData >> gtActionHtmlUrlFor: anAction [
	<gtAction>
	data isDictionary ifTrue: [
		data at: #html_url ifPresent: [ :htmlUrl |
			^ anAction explicit stencil: [
				BrButton new
					aptitude: BrGlamorousButtonWithIconAptitude;
					action:  [ WebBrowser openOn: htmlUrl ];
					icon: BrGlamorousIcons go asElement;
					label: 'Open web page' translated
			]
		]
	].
	^ anAction
]

{ #category : #accessing }
ClGhApiData >> gtDataFor: aView [
	<gtView>
	^ (data isArray ifTrue: [
		self arrayView: aView
	] ifFalse: [
		self dictionaryView: aView
	])
		title: 'Data';
		priority: 90;
		send: [ :each | self send: each value ]
]

{ #category : #accessing }
ClGhApiData >> gtDismissNotificationActionFor: anAction [
	<gtAction>
	data isDictionary ifTrue: [
		(data at: #unread ifAbsent: [ false ]) ifTrue: [
			^ anAction button
				icon: BrGlamorousIcons cancel;
				tooltip: 'Mark as read';
				priority: 1;
				action: [ :aButton | self class patch: (data at: #url) ]
		]
	].
	^ anAction
]

{ #category : #accessing }
ClGhApiData >> gtDisplayOn: stream [
	stream nextPutAll: self titleString
]

{ #category : #accessing }
ClGhApiData >> gtInspectorTitleString [
	^ self gtDisplayString
]

{ #category : #accessing }
ClGhApiData >> htmlUrl [
	^ data at: #html_url
]

{ #category : #accessing }
ClGhApiData >> login [
	^ data at: #login
]

{ #category : #accessing }
ClGhApiData >> send: each [ 
	(each isString and: [ each beginsWith: self class apiPrefix]) ifTrue: [
		^ ClGhApiData new data: (self class get: (self trimUrl: each))
	].
	(each isArray or: [each isDictionary]) ifTrue: [
		^ClGhApiData new data: each
	].
	^ each
]

{ #category : #accessing }
ClGhApiData >> state [
	^ data at: #state
]

{ #category : #accessing }
ClGhApiData >> title [
	^ data at: #title
]

{ #category : #accessing }
ClGhApiData >> titleString [
	^ data isDictionary ifTrue: [
		self titleStringFor: data
	] ifFalse: [
		'list'
	]
]

{ #category : #accessing }
ClGhApiData >> titleStringFor: d [
	| s |
	s := d at: #name ifAbsent: [ nil ].
	s := s ifNil: [ d at: #login ifAbsent: [ nil ] ].
	s := s ifNil: [ d at: #title ifAbsent: [ nil ] ].
	s := s ifNil: [ d at: #name ifAbsent: [ nil ] ].
	s := s ifNil: [ d at: #body ifAbsent: [ nil ] ].
	s := s ifNil: [ d at: #message ifAbsent: [ nil ] ].
	s := s ifNil: [ d at: #subject ifPresent: [ :d2 | self titleStringFor: d2 ] ].
	s := s ifNil: [ d at: #payload ifPresent: [ :d2 | self titleStringFor: d2 ] ].
	s := s ifNil: [ d at: #comment ifPresent: [ :d2 | self titleStringFor: d2 ] ].
	s := s ifNil: [ d at: #issue ifPresent: [ :d2 | self titleStringFor: d2 ] ].
	s := s ifNil: [ d at: #pull_request ifPresent: [ :d2 | self titleStringFor: d2 ] ].
	s := s ifNil: [ d at: #commits ifPresent: [ :commits | commits size printString , ' commits' ] ].
	s := s ifNil: [ 'something' ].
	^ s
]

{ #category : #accessing }
ClGhApiData >> trimUrl: url [
	| index |
	index := url findString: '{'.
	^ index = 0 ifTrue: [ url ] ifFalse: [ url copyFrom: 1 to: index - 1 ]
]

{ #category : #accessing }
ClGhApiData >> updatedAt [
	^ (data at: #updated_at) asDateAndTime asLocal
]
