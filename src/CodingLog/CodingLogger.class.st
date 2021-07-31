Class {
	#name : #CodingLogger,
	#superclass : #MemoryLogger,
	#instVars : [
		'hidden',
		'news'
	],
	#category : #CodingLog
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
CodingLogger >> gtGroupedFor: aView [
	<gtView>
	^ aView empty
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
	^ aView columnedList
		title: 'News' translated;
		priority: 50;
		items: [ self news values reverse ];
		column: 'Contents' translated 
			item: [ :each | 'markfirmware first viewed ', each printMethod, ' on ', each timestamp asDate printString, ' at ', each timestamp asTime print24 ]
]

{ #category : #accessing }
CodingLogger >> gtRecordingsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Recordings' translated;
		priority: 40;
		items: [ self recordings reverse ];
		updateWhen: Announcement in: [ self announcer ];
		column: 'Contents' translated 
			item: [ :each | String streamContents: [ :s | each printOneLineContentsOn: s ] ]
]

{ #category : #accessing }
CodingLogger >> gtSaveNewsActionFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousIcons savetodisk;
		tooltip: 'Save news to source code';
		priority: 1;
		action: [ :aButton | self class saveNews ]
]

{ #category : #accessing }
CodingLogger >> hide: aMethod [
	hidden add: aMethod printString
]

{ #category : #accessing }
CodingLogger >> isHidden: aMethod [
	^ hidden includes: aMethod printString
]

{ #category : #accessing }
CodingLogger >> methods [
	^ GtSearchIFixedMethodsFilter new methods:
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
CodingLogger >> patchClassesWithPatches: classesWithPatches [
	| withClassSideToo |
	withClassSideToo := classesWithPatches , (classesWithPatches collect: [ :each | each class ]).
	withClassSideToo do: [ :classWithPatches | | classWithStatusQuo classToPatch |
		classWithStatusQuo := classWithPatches superclass.
		classToPatch := classWithStatusQuo superclass.
		classWithPatches methods do: [ :method | | selector |
			selector := method selector.
    		(classToPatch >> selector) sourceCode = (classWithStatusQuo >> selector) sourceCode ifFalse: [
    			^ self
    		]
    	].
		classWithPatches methods do: [ :method | | selector |
			selector := method selector.
    		classToPatch compile: (classWithPatches >> selector) sourceCode
    	]
    ]
]

{ #category : #registering }
CodingLogger >> start [
	self patchClassesWithPatches: { CodingLogGtTextualCoderViewModel }.
	hidden := Set new.
	news := OrderedDictionary new.
	self startFor: CodingLogSignal
]

{ #category : #accessing }
CodingLogger >> unhide: aMethod [
	hidden remove: aMethod printString ifAbsent: []
]
