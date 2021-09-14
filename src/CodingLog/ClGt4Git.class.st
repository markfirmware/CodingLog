Class {
	#name : #ClGt4Git,
	#superclass : #ClGt4GitStatusQuo,
	#category : 'CodingLog-Patches'
}

{ #category : #accessing }
ClGt4Git >> buildListViewFor: aView [
	| result |
	result := aView columnedList
		title: 'Repositories' translated;
		priority: 50;
		send: [ :each | each ];
		updateWhen: IceRepositoryAnnouncement
			in: [ Iceberg announcer ];
		items: [ self repositories
			collect: [ :eachIceRepository | (GtGitRepository2 fromIcebergRepository: eachIceRepository) ] ];
		column: 'Repository' translated
			text: [ :each | 
			| description |
			description := each name asRopedText.
			each isModified
				ifTrue: [ description := ('*' , description asString) asRopedText foreground: (Color r: 0 g: 0.5 b: 0) ].
			description ]
			width: 200;
		column: 'Origin' translated
			text: [ :each | | origin | origin := each repository origin.
				origin isUndefined ifTrue: [ '' ] ifFalse: [ origin projectPath ] ]
			width: 200;
		column: 'Branch' translated
			text: [ :each | each headDescription ]
			width: 200;
		column: 'Status' translated
			text: [ :each | each status ]
			width: 200.
	^ result
]
