Class {
	#name : #CodingLogBlTaskAction,
	#superclass : #CodingLogBlTaskActionStatusQuo,
	#category : #CodingLog
}

{ #category : #accessing }
CodingLogBlTaskAction >> run [
	CodingLogger print: self action.
	self action isClosure
		ifTrue: [ self action cull: self ]
		ifFalse: [ self action value ]
]
