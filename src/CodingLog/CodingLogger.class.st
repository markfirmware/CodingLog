Class {
	#name : #CodingLogger,
	#superclass : #MemoryLogger,
	#instVars : [
		'hidden',
		'news',
		'executionCounters'
	],
	#category : #'CodingLog-Logging'
}

{ #category : #accessing }
CodingLogger class >> eraseInstanceRecordings [
	^ self instance reset
]

{ #category : #accessing }
CodingLogger class >> initialize [
	self start
]

{ #category : #accessing }
CodingLogger class >> instance [
	instance ifNil: [
		instance := self withRecordings: (STON fromString: self savedRecordingsSton).
		instance news: (STON fromString: self savedNewsSton).
		instance name: 'The Coding Log'
	].
	^ super instance
]

{ #category : #accessing }
CodingLogger class >> method: aMethod expanded: aBoolean [
	CodingLogMethodSignal new method: aMethod expanded: aBoolean; emit
]

{ #category : #accessing }
CodingLogger class >> print: anObject [
	CodingLogSignal new print: anObject; emit
]

{ #category : #accessing }
CodingLogger class >> saveNews [
	^ self class >> (self class compile: 'savedNewsSton', String cr, String tab, '^ ', (STON toString: self instance news) printString)
]

{ #category : #accessing }
CodingLogger class >> saveRecordings [
	^ self class >> (self class compile: 'savedRecordingsSton', String cr, String tab, '^ ', (STON toString: self instance recordings) printString)
]

{ #category : #accessing }
CodingLogger class >> savedNewsSton [
	^ 'OrderedDictionary{}'
]

{ #category : #accessing }
CodingLogger class >> savedRecordingsSton [
	^ 'OrderedCollection[]'
]

{ #category : #accessing }
CodingLogger >> activeMethods [
	^ GtSearchFixedMethodsFilter new methods: ((executionCounters select: [ :counter |
		counter count > 0 and: [ (CodingLogger instance isHidden: counter node method) not ] ])
			collect: [ :counter | counter node method ])
]

{ #category : #accessing }
CodingLogger >> gtActiveFor: aView [ 
	<gtView>
	^ aView forward
		title: 'Active';
		object: [ self activeMethods ];
		view: #gtItemsFor:
]

{ #category : #accessing }
CodingLogger >> gtClearActionFor: anAction [
	<gtAction>
	^ anAction button
		label: 'clear';
		tooltip: 'Clear execution counters';
		priority: 30;
		action: [ :aButton |
			self resetExecutionCounters.
			aButton phlow fireUpdateWish
		]
]

{ #category : #accessing }
CodingLogger >> gtGroupedFor: aView [
	<gtView>
	^ aView empty
]

{ #category : #accessing }
CodingLogger >> gtHideActiveActionFor: anAction [
	<gtAction>
	^ anAction button
		label: 'hide';
		tooltip: 'Hide active methods';
		priority: 20;
		action: [ :aButton |
			self hideActiveMethods.
			aButton phlow fireUpdateWish
		]
]

{ #category : #accessing }
CodingLogger >> gtInstallActionFor: anAction [
	<gtAction>
	^ anAction button
		label: 'install';
		tooltip: 'Install execution counters';
		priority: 40;
		action: [ :aButton |
			self installCoverage.
			aButton phlow fireUpdateWish
		]
]

{ #category : #accessing }
CodingLogger >> gtMethodsFor: aView [ 
	<gtView>
	^ aView forward
		title: 'Methods';
		object: [ self methods ];
		view: #gtItemsFor:
]

{ #category : #accessing }
CodingLogger >> gtNewsFor: aView [

	<gtView>
	^ aView list
		  title: 'News' translated;
		  priority: 50;
		  items: [ self news values reverse ];
		  itemText: [ :each | 
			  each timestamp asDate printString , ' '
			  , each timestamp asTime print24 , ' markfirmware first viewed '
			  , each printMethod ]
]

{ #category : #accessing }
CodingLogger >> gtRecordingsFor: aView [

	<gtView>
	^ aView list
		  title: 'Recordings' translated;
		  priority: 40;
		  items: [ self recordings reverse ];
		  updateWhen: Announcement in: [ self announcer ];
		  itemText: [ :each | 
			  String streamContents: [ :s | each printOneLineContentsOn: s ] ]
]

{ #category : #accessing }
CodingLogger >> gtSaveNewsActionFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousIcons savetodisk;
		tooltip: 'Save news to source code';
		priority:2 / 10;
		action: [ :aButton | self class saveNews ]
]

{ #category : #accessing }
CodingLogger >> gtUnhideAllActionFor: anAction [
	<gtAction>
	^ anAction button
		label: 'unhide';
		tooltip: 'Unhide all methods';
		priority: 25;
		action: [ :aButton |
			self unhideAllMethods.
			aButton phlow fireUpdateWish
		]
]

{ #category : #accessing }
CodingLogger >> gtUpdateActionFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousIcons refresh;
		tooltip: 'Update';
		priority: 1 / 10;
		action: [ :aButton | aButton phlow fireUpdateWish ]
]

{ #category : #accessing }
CodingLogger >> hide: aMethod [
	hidden add: aMethod printString
]

{ #category : #accessing }
CodingLogger >> hideActiveMethods [
	self activeMethods do: [ :each | self hide: each ]
]

{ #category : #accessing }
CodingLogger >> initializeWithRecordings: aCollection [
	super initializeWithRecordings: aCollection.
	executionCounters := OrderedCollection new
]

{ #category : #accessing }
CodingLogger >> installCoverage [
	| methods classes |
	methods := OrderedCollection new.
	classes := GtSearchClassesInPackageFilter forPackageNamed: 'CodingLog'.
	classes do: [ :aClass |
		methods addAll: aClass methods. methods addAll: aClass class methods
	].

	executionCounters := OrderedCollection new.
	methods do: [ :method |
		method ast links detect: [ :link |
			link metaObject class == ExecutionCounter
			] ifOne: [ :link |
				executionCounters add: link metaObject
			] ifNone: [
				executionCounters add: (ExecutionCounter installOn: method ast)
			]
		].
]

{ #category : #accessing }
CodingLogger >> isHidden: aMethod [
	^ hidden includes: aMethod printString
]

{ #category : #accessing }
CodingLogger >> methods [
	^ GtSearchFixedMethodsFilter new methods:
		((self recordings select: [:each | each isMethodSignal and: [ each compiledMethodExists and: [ each expanded and: [ (self isHidden: each compiledMethod) not ] ] ] ]) collect: [:each | each compiledMethod ]) asIdentitySet asOrderedCollection
]

{ #category : #accessing }
CodingLogger >> news [
	^ news
]

{ #category : #accessing }
CodingLogger >> news: someNews [
	news := someNews
]

{ #category : #accessing }
CodingLogger >> nextPut: aSignal [
	(aSignal isMethodSignal not or: [ aSignal expanded ]) ifTrue: [ | key |
		super nextPut: aSignal.
		aSignal compiledMethodExists ifTrue: [
			key := aSignal compiledMethod printString.
			(news includesKey: key) ifFalse: [
				news at: key put: aSignal
			]
		]
	]
]

{ #category : #accessing }
CodingLogger >> resetExecutionCounters [
	executionCounters do: #reset
]

{ #category : #registering }
CodingLogger >> start [
	hidden := Set new.
	news := OrderedDictionary new.
	self startFor: CodingLogSignal
]

{ #category : #accessing }
CodingLogger >> unhide: aMethod [
	hidden remove: aMethod printString ifAbsent: []
]

{ #category : #accessing }
CodingLogger >> unhideAllMethods [
	hidden copy do: [ :each | self unhide: each ]
]
