Class {
	#name : 'CodingLogGtTextualCoderViewModelStatusQuo',
	#superclass : 'GtTextualCoderViewModel',
	#category : 'CodingLog'
}

{ #category : 'api - expansion' }
CodingLogGtTextualCoderViewModelStatusQuo >> expanded: aBoolean [
	expanded = aBoolean
		ifTrue: [ ^ self ].

	expanded := aBoolean.
	self notifyExpansionChanged: expanded
]
