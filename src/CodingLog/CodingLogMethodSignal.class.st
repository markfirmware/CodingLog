Class {
	#name : #CodingLogMethodSignal,
	#superclass : #BeaconSignal,
	#instVars : [
		'selector',
		'classIsMeta',
		'className'
	],
	#category : #CodingLog
}

{ #category : #accessing }
CodingLogMethodSignal class >> method: aMethod [
	^ self new method: aMethod
]

{ #category : #accessing }
CodingLogMethodSignal >> classIsMeta [
	^ classIsMeta
]

{ #category : #accessing }
CodingLogMethodSignal >> className [
	^ className
]

{ #category : #accessing }
CodingLogMethodSignal >> method [
	^ (classIsMeta
		ifTrue: [ (Smalltalk at: className) class ]
	ifFalse: [ (Smalltalk at: className) ]) methodNamed: selector
]

{ #category : #accessing }
CodingLogMethodSignal >> method: aMethod [
	className := aMethod methodClass instanceSide name.
	classIsMeta := aMethod methodClass isMeta.
	selector := aMethod selector
]

{ #category : #accessing }
CodingLogMethodSignal >> printOneLineContentsOn: stream [
	stream nextPutAll: self method printString
]

{ #category : #accessing }
CodingLogMethodSignal >> selector [
	^ selector
]
