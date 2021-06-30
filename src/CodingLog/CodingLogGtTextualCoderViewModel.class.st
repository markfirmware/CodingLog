Class {
	#name : #CodingLogGtTextualCoderViewModel,
	#superclass : #CodingLogGtTextualCoderViewModelStatusQuo,
	#category : #CodingLog
}

{ #category : #'api - expansion' }
CodingLogGtTextualCoderViewModel >> expanded: aBoolean [
	expanded = aBoolean
		ifTrue: [ ^ self ].

	expanded := aBoolean.
	(expanded and: [ self coder compiledMethod notNil ]) ifTrue: [
		(CodingLogMethodSignal method: self coder compiledMethod) emit ].
	self notifyExpansionChanged: expanded
]
