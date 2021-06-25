Class {
	#name : #CodingLogger,
	#superclass : #MemoryLogger,
	#category : #CodingLog
}

{ #category : #accessing }
CodingLogger class >> example [
	^ self new start
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
CodingLogger >> patch: classWithPatch selector: selector [
	| classWithStatusQuo classToPatch |
	classWithStatusQuo := classWithPatch superclass.
	classToPatch := classWithStatusQuo superclass.
    (classToPatch >> selector) sourceCode
    	= (classWithStatusQuo >> selector) sourceCode
    		ifTrue: [
    			classToPatch compile: (classWithPatch >> selector) sourceCode
    		]
]

{ #category : #registering }
CodingLogger >> start [
	self patch: CodingLogGtTextualCoderViewModel selector: #expanded:.
	self startFor: CodingLogMethodSignal
]
