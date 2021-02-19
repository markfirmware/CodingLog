Class {
	#name : #CodingLogger,
	#superclass : #MemoryLogger,
	#category : #CodingLog
}

{ #category : #accessing }
CodingLogger >> gtRecordingsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Recordings' translated;
		priority: 50;
		items: [ self recordings reverse ];
		updateWhen: Announcement in: [ self announcer ];
		column: 'Contents' translated 
			item: [ :each | String streamContents: [ :s | each printOneLineContentsOn: s ] ]
]

{ #category : #registering }
CodingLogger >> start [
	self startFor: CodingLogSignal
]
