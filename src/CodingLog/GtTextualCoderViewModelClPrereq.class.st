Class {
	#name : #GtTextualCoderViewModelClPrereq,
	#superclass : #GtTextualCoderViewModel,
	#category : #'CodingLog-Patches'
}

{ #category : #'api - expansion' }
GtTextualCoderViewModelClPrereq >> expanded: aBoolean [
	expanded = aBoolean
		ifTrue: [ ^ self ].

	expanded := aBoolean.
	self notifyExpansionChanged: expanded
]
