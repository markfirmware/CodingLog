Class {
	#name : #CodingLogGtTextualCoderViewModelStatusQuo,
	#superclass : #GtTextualCoderViewModel,
	#category : 'CodingLog-Patches'
}

{ #category : #'api - expansion' }
CodingLogGtTextualCoderViewModelStatusQuo >> expanded: aBoolean [
	expanded = aBoolean
		ifTrue: [ ^ self ].

	expanded := aBoolean.
	self notifyExpansionChanged: expanded
]
