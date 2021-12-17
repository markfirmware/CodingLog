Class {
	#name : #GtTextualCoderViewModelClPatch,
	#superclass : #GtTextualCoderViewModelClPrereq,
	#category : #'CodingLog-Patches'
}

{ #category : #'api - expansion' }
GtTextualCoderViewModelClPatch >> expanded: aBoolean [
	expanded = aBoolean
		ifTrue: [ ^ self ].

	expanded := aBoolean.
	((self coder respondsTo: #compiledMethod) and: [ self coder compiledMethod notNil ]) ifTrue: [
		CodingLogger method: self coder compiledMethod expanded: aBoolean ].
	self notifyExpansionChanged: expanded
]
