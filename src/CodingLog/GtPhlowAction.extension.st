Extension { #name : #GtPhlowAction }

{ #category : #'*CodingLog' }
GtPhlowAction >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: (self tooltipBuilder text);
		nextPut: $)
]
