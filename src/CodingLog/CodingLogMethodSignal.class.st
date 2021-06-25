Class {
	#name : #CodingLogMethodSignal,
	#superclass : #CodingLogSignal,
	#instVars : [
		'method'
	],
	#category : #CodingLog
}

{ #category : #accessing }
CodingLogMethodSignal class >> method: aMethod [
	^ self new method: aMethod
]

{ #category : #accessing }
CodingLogMethodSignal >> method [
	^ method
]

{ #category : #accessing }
CodingLogMethodSignal >> method: aMethod [
	method := aMethod
]

{ #category : #accessing }
CodingLogMethodSignal >> printOneLineContentsOn: stream [
	stream nextPutAll: method printString
]
