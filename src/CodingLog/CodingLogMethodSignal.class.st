Class {
	#name : #CodingLogMethodSignal,
	#superclass : #CodingLogSignal,
	#instVars : [
		'className1',
		'selector'
	],
	#category : #CodingLog
}

{ #category : #accessing }
CodingLogMethodSignal class >> class: aClass selector: aSelector [
^self new className1: aClass name; selector: aSelector; yourself
]

{ #category : #accessing }
CodingLogMethodSignal >> className1 [
	^ className1
]

{ #category : #accessing }
CodingLogMethodSignal >> className1: anObject [
	className1 := anObject
]

{ #category : #accessing }
CodingLogMethodSignal >> printOneLineContentsOn: stream [
	stream
		nextPutAll: self className1;
		nextPutAll: '>>';
		nextPutAll: self selector
]

{ #category : #accessing }
CodingLogMethodSignal >> selector [
	^ selector
]

{ #category : #accessing }
CodingLogMethodSignal >> selector: anObject [
	selector := anObject
]
