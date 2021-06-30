Class {
	#name : #CodingLogger,
	#superclass : #MemoryLogger,
	#category : #CodingLog
}

{ #category : #accessing }
CodingLogger class >> initialize [
	[ instance := self fromStonFile: (FileSystem workingDirectory parent lastFileFor: self name extension: 'stgz')
	] on: Error
	do: [].
	self writeFilename: self name, '.stgz'.
	self writePeriod: 5 minutes.
	self start.
	self startAutoSaving
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
		(self recordings collect: [:each | each method]) asIdentitySet asOrderedCollection
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
