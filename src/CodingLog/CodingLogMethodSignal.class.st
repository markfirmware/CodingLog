Class {
	#name : #CodingLogMethodSignal,
	#superclass : #CodingLogSignal,
	#category : 'CodingLog'
}

{ #category : #accessing }
CodingLogMethodSignal >> classIsMeta [
	^ self properties at: #classIsMeta
]

{ #category : #accessing }
CodingLogMethodSignal >> classIsMeta: aBoolean [
	self properties at: #classIsMeta put: aBoolean
]

{ #category : #accessing }
CodingLogMethodSignal >> className [
	^ self properties at: #className
]

{ #category : #accessing }
CodingLogMethodSignal >> className: aSymbol [
	self properties at: #className put: aSymbol
]

{ #category : #accessing }
CodingLogMethodSignal >> compiledMethod [
	| class |
	class := Smalltalk at: self className.
	self classIsMeta ifTrue: [
		class := class class
	].
	^ class methodNamed: self selector
]

{ #category : #accessing }
CodingLogMethodSignal >> compiledMethodExists [
	[ self compiledMethod]
		on: Exception
		do: [ :ex | ^ false ].
	^ true
]

{ #category : #accessing }
CodingLogMethodSignal >> expanded [
	^ self properties at: #expanded
]

{ #category : #accessing }
CodingLogMethodSignal >> expanded: aBoolean [
	^ self properties at: #expanded put: aBoolean
]

{ #category : #accessing }
CodingLogMethodSignal >> gtMethodFor: aView [ 
	<gtView>
	self compiledMethodExists ifFalse: [
		^ aView empty
	].
	^ aView forward
		priority: 0;
		title: 'Method';
		object: [ GtSearchIFixedMethodsFilter new methods: (OrderedCollection with: self compiledMethod) ];
		view: #gtItemsFor:
]

{ #category : #accessing }
CodingLogMethodSignal >> isMethodSignal [
	^ true
]

{ #category : #accessing }
CodingLogMethodSignal >> method: aMethod expanded: aBoolean [
	self className:  aMethod methodClass instanceSide name.
	self classIsMeta: aMethod methodClass isMeta.
	self selector: aMethod selector.
	self expanded: aBoolean
]

{ #category : #accessing }
CodingLogMethodSignal >> printMethod [
	^ String streamContents: [ :s | self printMethodOn: s ]
]

{ #category : #accessing }
CodingLogMethodSignal >> printMethodOn: stream [
	stream nextPutAll: self className;
	nextPutAll: (self classIsMeta ifTrue: [' class'] ifFalse: [ '' ]);
	nextPutAll: '>>';	nextPutAll: self selector
]

{ #category : #accessing }
CodingLogMethodSignal >> printOneLineContentsOn: stream [
	self compiledMethodExists ifTrue: [
		stream nextPutAll: self compiledMethod printString
	] ifFalse: [
		stream nextPutAll: 'Not found: '.
		self printMethodOn: stream
	]
]

{ #category : #accessing }
CodingLogMethodSignal >> selector [
	^ self properties at: #selector
]

{ #category : #accessing }
CodingLogMethodSignal >> selector: aSymbol [
	self properties at: #selector put: aSymbol
]
