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
	expanded ifTrue: [
		(CodingLogMethodSignal method: self coder compiledMethod) emit ].
	self notifyExpansionChanged: expanded
]
