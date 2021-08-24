Class {
	#name : 'CodingLogGtPhlowLabelBuilderStatusQuo',
	#superclass : 'GtPhlowLabelBuilder',
	#category : 'CodingLog'
}

{ #category : 'accessing' }
CodingLogGtPhlowLabelBuilderStatusQuo >> build [
	<return: #BlRopedText or: #String>
	^ self titleOfObject: self object
]
