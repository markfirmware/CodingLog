Class {
	#name : #CodingLogger,
	#superclass : #MemoryLogger,
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
		instance name: 'The Coding Log'
	].
	^ super instance
]

{ #category : #accessing }
CodingLogger class >> saveRecordings [
	^ self class >> (self class compile: 'savedRecordingsSton', String cr, String tab, '^ ', (STON toString: self instance recordings) printString)
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
CodingLogger >> methods [
	^ GtSearchIFixedMethodsFilter new methods:
		((self recordings select: [:each | each compiledMethodExists and: [ each expanded ] ]) collect: [:each | each compiledMethod ]) asIdentitySet asOrderedCollection
]

{ #category : #accessing }
CodingLogger >> nextPut: aSignal [
	aSignal expanded ifTrue: [
		super nextPut: aSignal
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
	self startFor: CodingLogMethodSignal
]
