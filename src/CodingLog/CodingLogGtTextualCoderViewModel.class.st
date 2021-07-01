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
	((self coder respondsTo: #compiledMethod) and: [ self coder compiledMethod notNil ]) ifTrue: [
		(CodingLogMethodSignal method: self coder compiledMethod expanded: aBoolean) emit ].
	self notifyExpansionChanged: expanded
]
