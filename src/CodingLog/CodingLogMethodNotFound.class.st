Class {
	#name : #CodingLogMethodNotFound,
	#superclass : #Object,
	#instVars : [
		'selector',
		'classIsMeta',
		'className'
	],
	#category : #CodingLog
}

{ #category : #accessing }
CodingLogMethodNotFound class >> fromSignal: aSignal [
	^ self new fromSignal: aSignal
]

{ #category : #accessing }
CodingLogMethodNotFound >> fromSignal: aSignal [
	className := aSignal className.
	classIsMeta := aSignal classIsMeta.
	selector := aSignal selector
]

{ #category : #accessing }
CodingLogMethodNotFound >> printString [
	^ 'Not found: ' , className, (classIsMeta ifTrue: [' class'] ifFalse: ['']), '>>', selector
]
