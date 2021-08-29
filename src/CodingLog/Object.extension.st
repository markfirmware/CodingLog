Extension { #name : 'Object' }

{ #category : '*CodingLog' }
Object >> gtTitleString [
	^ self gtDisplayString
]

{ #category : '*CodingLog' }
Object >> titleForBuilder: builder [
	^ builder titleOfObject: self
]
