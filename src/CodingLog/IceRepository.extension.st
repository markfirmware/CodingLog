Extension { #name : #IceRepository }

{ #category : #'*CodingLog' }
IceRepository class >> thisRepository [
	^ self registry detect: [ :repo | repo location = '..' asFileReference]
]
