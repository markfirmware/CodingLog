Class {
	#name : #GtHomeCodingLogSection,
	#superclass : #GtHomeSection,
	#instVars : [
		'cardsContainer',
		'sectionContainer'
	],
	#category : #CodingLog
}

{ #category : #accessing }
GtHomeCodingLogSection >> addReadme [
	cardsContainer addChild: (self
			 newHeaderCardWithTitle: 'Repository lepiter readme'
			 description: IceRepository thisRepository origin projectPath
			 size: 200 @ 150
			 content: (BrLabel new
					  text: 'README';
					  aptitude: BrGlamorousLabelAptitude new bold;
					  padding: (BlInsets all: 20)) asScalableElement
			 action: [ :card | 
				 | database count startPage dbDir dbName |
				 dbName := 'readme.lepiterdb'.
				 dbDir := FileSystem disk workingDirectory parent / dbName.
				 (LeDatabasesRegistry defaultLogicalDatabase properties 
					  isDirectoryRegistered: dbDir) ifFalse: [ 
					 LeDatabasesRegistry defaultLogicalDatabase properties 
						 addRegisteredDirectory: dbDir.
					 LeDatabasesRegistry defaultLogicalDatabase reload ].
				 count := 0.
				 [database isNil] whileTrue: [
				 	database := LeDatabasesRegistry defaultLogicalDatabase databases detect: [ :each |
				 		each monitor localRoot = dbDir] ifNone: [nil].
				 		database ifNil: [
				 			count := count + 1.
				 			count = 100 ifTrue: [ Exception signal: 'cannot load readme' ].
				 			(Delay forMilliseconds: 100) wait
				 		]
				 ].
				 startPage := database pageNamed: 'readme'.
				 GtWorldUtility
					 showSpaceWithTitle: startPage title
					 inPagerWith:
					 [ startPage asLepiterPagePhlowTool asElementDo: [ :e | e ] ]
						 asStencil
					 from: card ])
]

{ #category : #accessing }
GtHomeCodingLogSection >> addRepositoryShow [
	cardsContainer addChild: (self
		 newShowCardWithTitle: 'The Coding Log'
		 slideshow: [ GtLiveShow createWithArrowsVisible: CodingLogShow new ]
		 description: 'Keep track of your coding effort')
]

{ #category : #accessing }
GtHomeCodingLogSection >> create [
	sectionContainer := self newSectionContainer.
	sectionContainer addChild: (self newSectionTitle: 'Coding Log').
	cardsContainer := self newCardsContainer.
	sectionContainer addChild: cardsContainer.
	self addReadme.
	self addRepositoryShow.
	^ sectionContainer
]
