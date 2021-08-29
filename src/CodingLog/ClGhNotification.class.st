Class {
	#name : 'ClGhNotification',
	#superclass : 'ClGhApiData',
	#category : 'CodingLog-GitHub'
}

{ #category : 'accessing' }
ClGhNotification >> gtActionOpenCheckSuiteFor: anAction [
	<gtAction>
	data isDictionary ifTrue: [
		(self isSubjectTypeCheckSuite) ifTrue: [
			^ anAction explicit stencil: [
				BrButton new
					aptitude: BrGlamorousButtonWithIconAptitude;
					action:  [ WebBrowser openOn: (self repository at: #html_url) , '/actions' ];
					icon: BrGlamorousIcons go asElement;
					label: 'Open actions page' translated
			]
		]
	].
	^ anAction
]

{ #category : 'accessing' }
ClGhNotification >> gtActionOpenReleaseFor: anAction [
	<gtAction>
	data isDictionary ifTrue: [
		(self isSubjectTypeRelease) ifTrue: [
			^ anAction explicit stencil: [
				BrButton new
					aptitude: BrGlamorousButtonWithIconAptitude;
					action:  [ WebBrowser openOn: ((self class getDictionary: (self subject at: #url)) at: #html_url) ];
					icon: BrGlamorousIcons go asElement;
					label: 'Open release page' translated
			]
		]
	].
	^ anAction
]

{ #category : 'accessing' }
ClGhNotification >> gtDismissNotificationActionFor: anAction [
	<gtAction>
	self unread ifFalse: [ ^ anAction ].
	^ anAction button
		icon: BrGlamorousIcons cancel;
		tooltip: 'Dismiss Notification';
		priority: 1;
		action: [ :aButton | self requestDismissal ]
]

{ #category : 'accessing' }
ClGhNotification >> gtDisplayOn: stream [
	stream
		nextPutAll: self updatedAt printString;
		nextPutAll: ' ';
		nextPutAll: self subjectType;
		nextPutAll: ' ';
		nextPutAll: self subjectTitle
]

{ #category : 'accessing' }
ClGhNotification >> isSubjectTypeCheckSuite [
	^ self subjectType = 'CheckSuite'
]

{ #category : 'accessing' }
ClGhNotification >> isSubjectTypeRelease [
	^ self subjectType = 'Release'
]

{ #category : 'accessing' }
ClGhNotification >> repository [
	^ data at: #repository
]

{ #category : 'accessing' }
ClGhNotification >> requestDismissal [
	self class patch: self url
]

{ #category : 'accessing' }
ClGhNotification >> subject [
	^ data at: #subject
]

{ #category : 'accessing' }
ClGhNotification >> subjectTitle [
	^ self subject at: #title
]

{ #category : 'accessing' }
ClGhNotification >> subjectType [
	^self subject at: #type
]

{ #category : 'accessing' }
ClGhNotification >> unread [
	^ data at: #unread
]

{ #category : 'accessing' }
ClGhNotification >> url [
	^ data at: #url
]
