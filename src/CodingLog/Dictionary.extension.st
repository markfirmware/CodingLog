Extension { #name : #Dictionary }

{ #category : #'*CodingLog' }
Dictionary >> at: firstKey at: secondKey at: thirdKey ifAbsent: aZeroArgBlock [
		"Return the object stored in the second dictionary at secondKey. The second dictionary is accessed via the key firstKey. Execute aZeroArgBlock in case one of the key is wrong."
		
	| subDictionary |
	subDictionary := self at: firstKey ifAbsent: [ ^ aZeroArgBlock value ].
	subDictionary := self at: secondKey ifAbsent: [ ^ aZeroArgBlock value ].
	^ subDictionary at: thirdKey ifAbsent: aZeroArgBlock
]
