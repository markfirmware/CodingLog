Class {
	#name : 'CodingLogBlTaskActionStatusQuo',
	#superclass : 'BlTaskAction',
	#category : 'CodingLog'
}

{ #category : 'accessing' }
CodingLogBlTaskActionStatusQuo >> run [
	self action isClosure
		ifTrue: [ self action cull: self ]
		ifFalse: [ self action value ]
]
