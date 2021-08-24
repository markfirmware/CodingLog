Class {
	#name : 'CodingLogGtPhlowLabelBuilder',
	#superclass : 'CodingLogGtPhlowLabelBuilderStatusQuo',
	#category : 'CodingLog'
}

{ #category : 'accessing' }
CodingLogGtPhlowLabelBuilder >> build [
	^ self object titleForBuilder: self
]
