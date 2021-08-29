Class {
	#name : 'CodingLogGtPhlowLabelBuilder',
	#superclass : 'CodingLogGtPhlowLabelBuilderStatusQuo',
	#category : 'CodingLog-Patches'
}

{ #category : 'accessing' }
CodingLogGtPhlowLabelBuilder >> build [
	^ self object titleForBuilder: self
]
