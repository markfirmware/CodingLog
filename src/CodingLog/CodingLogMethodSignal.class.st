Class {
	#name : #CodingLogMethodSignal,
	#superclass : #BeaconSignal,
	#category : #CodingLog
}

{ #category : #accessing }
CodingLogMethodSignal class >> method: aMethod expanded: aBoolean [
	^ self new method: aMethod expanded: aBoolean
]

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
	| method |
	method := self method.
	(method isKindOf: CodingLogMethodNotFound) ifTrue: [
		^ aView empty
	].
	^ aView forward
		priority: 0;
		title: 'Method';
		object: [ GtSearchIFixedMethodsFilter new methods: (OrderedCollection with: method) ];
		view: #gtItemsFor:
]

{ #category : #accessing }
CodingLogMethodSignal >> method [
	^ [ (self classIsMeta
		ifTrue: [ (Smalltalk at: self className) class ]
	ifFalse: [ (Smalltalk at: self className) ]) methodNamed: self selector
	] on: Exception do: [:e |
		CodingLogMethodNotFound fromSignal: self
	]
]

{ #category : #accessing }
CodingLogMethodSignal >> method: aMethod expanded: aBoolean [
	self className:  aMethod methodClass instanceSide name.
	self classIsMeta: aMethod methodClass isMeta.
	self selector: aMethod selector.
	self expanded: aBoolean
]

{ #category : #accessing }
CodingLogMethodSignal >> printOneLineContentsOn: stream [
	stream nextPutAll: self method printString
]

{ #category : #accessing }
CodingLogMethodSignal >> selector [
	^ self properties at: #selector
]

{ #category : #accessing }
CodingLogMethodSignal >> selector: aSymbol [
	self properties at: #selector put: aSymbol
]
