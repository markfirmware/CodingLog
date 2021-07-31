Class {
	#name : #GhSession,
	#superclass : #Object,
	#classInstVars : [
		'cache',
		'token'
	],
	#category : #CodingLog
}

{ #category : #accessing }
GhSession class >> apiPrefix [
	^ 'https://api.github.com/'
]

{ #category : #accessing }
GhSession class >> client [
	| client |
	client := ZnClient new
		accept: (ZnMimeType main: 'application' sub: 'vnd.github.v3+json').
	token notNil ifTrue: [
		client headerAt: 'Authorization' put: 'token ' , token
	].
	^ client
]

{ #category : #accessing }
GhSession class >> defaultPageSize [
	^ 30
]

{ #category : #accessing }
GhSession class >> fullUrl: path [
	^ (path beginsWith: self apiPrefix) ifTrue: [path] ifFalse: [self apiPrefix , path]
]

{ #category : #accessing }
GhSession class >> get: path [
	| url |
	url := self fullUrl: path.
	^ cache at: url ifAbsentPut: [
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
GhSession class >> getArray: path [
	| url |
	url := self fullUrl: path.
	^ cache at: url ifAbsentPut: [ self items: url ]
]

{ #category : #accessing }
GhSession class >> getArray: path of: aClass sortKey: selector [ 
	^ ((self getArray: path) collect: [ :each | aClass new data: each ]) sorted: [ :a :b | (a perform: selector) > (b perform: selector) ]
]

{ #category : #accessing }
GhSession class >> getDictionary: path [
	| url |
	url := self fullUrl: path.
	^ cache at: url ifAbsentPut: [
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
GhSession class >> getDictionary: path of: aClass [
	^ aClass new data: (self getDictionary: path)
]

{ #category : #accessing }
GhSession class >> initialize [
	super initialize.
	cache := Dictionary new
]

{ #category : #accessing }
GhSession class >> items: url [
	^ self items: OrderedCollection new pageNumber: 1 url: url
]

{ #category : #accessing }
GhSession class >> items: items pageNumber: pageNumber url: url [
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
		onError: [ :e | self halt. items asArray ]
]

{ #category : #accessing }
GhSession class >> pageSize [
	^ 100
]

{ #category : #accessing }
GhSession class >> patch: path [
	| url |
	url := (path beginsWith: self apiPrefix) ifTrue: [path] ifFalse: [self apiPrefix , path].
	^ self client
		url: url;
		patch
]

{ #category : #accessing }
GhSession class >> purge [
	cache removeAll
]

{ #category : #accessing }
GhSession class >> purge: path [
	| url |
	url := (path beginsWith: self apiPrefix) ifTrue: [path] ifFalse: [self apiPrefix , path].
	cache removeKey: url ifAbsent: []
]

{ #category : #accessing }
GhSession class >> token: aToken [
	token := aToken
]

{ #category : #accessing }
GhSession class >> user [
	^ self getDictionary: 'user'
]
