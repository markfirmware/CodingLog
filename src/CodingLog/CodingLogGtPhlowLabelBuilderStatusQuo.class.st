Class {
	#name : 'CodingLogGtPhlowLabelBuilderStatusQuo',
	#superclass : 'GtPhlowLabelBuilder',
	#category : 'CodingLog-Patches'
}

{ #category : 'accessing' }
CodingLogGtPhlowLabelBuilderStatusQuo >> build [
	<return: #BlRopedText or: #String>
	^ self titleOfObject: self object
]
