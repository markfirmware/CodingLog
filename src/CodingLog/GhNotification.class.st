Class {
	#name : 'GhNotification',
	#superclass : 'Object',
	#instVars : [
		'data'
	],
	#category : 'CodingLog-CodingLog'
}

{ #category : 'accessing' }
GhNotification >> data: dictionary [
	data := dictionary
]

{ #category : 'accessing' }
GhNotification >> gtDismissNotificationActionFor: anAction [
	<gtAction>
	self unread ifFalse: [ ^ anAction ].
	^ anAction button
		icon: BrGlamorousIcons cancel;
		tooltip: 'Dismiss Notification';
		priority: 1;
		action: [ :aButton | self requestDismissal ]
]

{ #category : 'accessing' }
GhNotification >> gtDisplayOn: stream [
	stream
		nextPutAll: self updatedAt printString;
		nextPutAll: ' ';
		nextPutAll: self subjectType;
		nextPutAll: ' ';
		nextPutAll: self subjectTitle
]

{ #category : 'accessing' }
GhNotification >> requestDismissal [
	GhSession patch: self url
]

{ #category : 'accessing' }
GhNotification >> subject [
	^ data at: #subject
]

{ #category : 'accessing' }
GhNotification >> subjectInstance [
	| aClass |
	aClass := GhNode.
	self subjectType = #Issue ifTrue: [ aClass := GhIssue ].
	^ (GhSession getDictionary: self subjectUrl of: aClass)
]

{ #category : 'accessing' }
GhNotification >> subjectTitle [
	^ self subject at: #title
]

{ #category : 'accessing' }
GhNotification >> subjectType [
	^self subject at: #type
]

{ #category : 'accessing' }
GhNotification >> subjectUrl [
	^ self subject at: #url
]

{ #category : 'accessing' }
GhNotification >> unread [
	^ data at: #unread
]

{ #category : 'accessing' }
GhNotification >> updatedAt [
	^ (data at: #updated_at) asDateAndTime asLocal
]

{ #category : 'accessing' }
GhNotification >> url [
	^ data at: #url
]
