Class {
	#name : 'GhIssue',
	#superclass : 'Object',
	#instVars : [
		'data'
	],
	#category : 'CodingLog-CodingLog'
}

{ #category : 'accessing' }
GhIssue >> body [
	^ data at: #body
]

{ #category : 'accessing' }
GhIssue >> commentsUrl [
	^ data at: #comments_url
]

{ #category : 'accessing' }
GhIssue >> data: dictionary [
	data := dictionary
]

{ #category : 'accessing' }
GhIssue >> gtActionWebBrowseFor: anAction [
	<gtAction>
	|  button |
	^ anAction explicit stencil: [
		button := BrButton new.
		button
			aptitude: BrGlamorousButtonWithIconAptitude;
			action:  [ WebBrowser openOn: self htmlUrl ];
			icon: BrGlamorousIcons go asElement;
			label: 'Open in OS' translated.
	]
]

{ #category : 'accessing' }
GhIssue >> gtDisplayOn: stream [
	stream nextPutAll: self title
]

{ #category : 'accessing' }
GhIssue >> gtOverviewFor: aView [
	<gtView>
	^ aView list
		title: 'Overview';
		items: [ | list |
			list := OrderedCollection new.
			list add: self title.
			list add: self body.
			list addAll: (((GhSession getArray: self commentsUrl) sorted: [ :a :b | (a at: #created_at) > (b at: #created_at) ]) collect: [ :each | each at: #body ]).
			list
		]
]

{ #category : 'accessing' }
GhIssue >> htmlUrl [
	^ data at: #html_url
]

{ #category : 'accessing' }
GhIssue >> state [
	^ data at: #state
]

{ #category : 'accessing' }
GhIssue >> title [
	^ data at: #title
]

{ #category : 'accessing' }
GhIssue >> updatedAt [
	^ (data at: #updated_at) asDateAndTime asLocal
]
