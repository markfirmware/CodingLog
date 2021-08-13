Class {
	#name : 'GtHomeCodingLogSection',
	#superclass : 'GtHomeSection',
	#category : 'CodingLog'
}

{ #category : 'accessing' }
GtHomeCodingLogSection >> create [
	| sectionContainer cardsContainer |
	sectionContainer := self newSectionContainer.
	sectionContainer addChild: (self newSectionTitle: 'Coding Log').
	cardsContainer := self newCardsContainer.
	cardsContainer addChild: (self
		newShowCardWithTitle: 'The Coding Log'
		slideshow: [ GtLiveShow createWithArrowsVisible: CodingLogShow new ]
		description: 'Keep track of your coding effort').
	cardsContainer addChild: (self
		newHeaderCardWithTitle: 'Repository lepiter readme'
		description: 'Repository lepiter readme'
		size: 200@150
		content:
			(BrLabel new
				text: 'Glamorous README';
				aptitude: BrGlamorousLabelAptitude new
					bold;
				padding: (BlInsets all: 20)) asScalableElement
		action: [ :card | | database startPage dbDir dbNameSegments dbName |
			dbDir := FileSystem disk workingDirectory parent / 'readme.lepiterdb'.
			dbNameSegments := dbDir path segments last: (3 min: dbDir path segments size).
			dbName := String streamContents: [ :s | (Path withAll: dbNameSegments) printPathOn: s ].
			LeDatabasesRegistry defaultLogicalDatabase properties addRegisteredDirectory: dbDir.
			LeDatabasesRegistry default defaultLogicalDatabase reload.
			database := LeDatabasesRegistry default currentLoadedDefaultLogicalDatabase databaseNamed: dbName.
			startPage := database pageNamed: 'readme'.
			GtWorldUtility 
				showSpaceWithTitle: startPage title
				inPagerWith: [ startPage
					asLepiterPagePhlowTool asElementDo: [ :e | e ] ] asStencil
				from: card ]).

	sectionContainer addChild: cardsContainer.
	^ sectionContainer
]
