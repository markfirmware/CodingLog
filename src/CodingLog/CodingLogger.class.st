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
	| methodsFilter |
	methodsFilter := GtSearchIFixedMethodsFilter new.
	self recordings do: [ :each |
		(methodsFilter includesMethod: each method) not ifTrue: [
			methodsFilter methods add: each method ] ].
	^ methodsFilter
]

{ #category : #registering }
CodingLogger >> start [
	self startFor: CodingLogSignal
]
