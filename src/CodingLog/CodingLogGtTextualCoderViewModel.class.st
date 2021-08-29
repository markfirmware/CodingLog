Class {
	#name : 'CodingLogGtTextualCoderViewModel',
	#superclass : 'CodingLogGtTextualCoderViewModelStatusQuo',
	#category : 'CodingLog-Patches'
}

{ #category : 'api - expansion' }
CodingLogGtTextualCoderViewModel >> expanded: aBoolean [
	expanded = aBoolean
		ifTrue: [ ^ self ].

	expanded := aBoolean.
	((self coder respondsTo: #compiledMethod) and: [ self coder compiledMethod notNil ]) ifTrue: [
		CodingLogger method: self coder compiledMethod expanded: aBoolean ].
	self notifyExpansionChanged: expanded
]
