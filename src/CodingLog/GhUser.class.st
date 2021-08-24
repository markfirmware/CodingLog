Class {
	#name : 'GhUser',
	#superclass : 'Object',
	#instVars : [
		'data'
	],
	#category : 'CodingLog'
}

{ #category : 'accessing' }
GhUser >> data: dictionary [
	data := dictionary
]

{ #category : 'accessing' }
GhUser >> gtDisplayRunOn: stream [
	| status |
	status := self rawData at: #status.
	stream
		nextPutAll: (self rawData at: #updated_at);
		nextPutAll: String space;
		nextPutAll: (status = 'completed' ifTrue: [(self rawData at: #conclusion)] ifFalse: [status])
]

{ #category : 'accessing' }
GhUser >> gtEventsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Events';
		priority: 20;
		send: [ :each | GhNode new data: each ];
		items: [
			((GhSession getArray: 'users/' , self userName , '/events') select: [ :each |
				(each at: #payload at: #action ifAbsent: [ '' ]) ~= 'closed'
			]) sorted: [ :a : b |
				(a at: #created_at) > (b at: #created_at)
			]
		];
		column: 'Created' text: [ :each | (each at: #created_at) asDateAndTime asLocal ];
		column: 'Type' text: [ :each | each at: #type ];
		column: 'Actor' text: [ :each | each at: #actor at: #display_login ]
]

{ #category : 'accessing' }
GhUser >> gtNotificationsFor: aView [
	<gtView>
	^ aView list
		title: 'Notifications';
		priority: 10;
		actionUpdateButton;
		items: [
			GhSession purge: 'notifications'.
			GhSession getArray: 'notifications' of: GhNotification sortKey: #updatedAt
		]
]

{ #category : 'accessing' }
GhUser >> gtOpenIssuesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Issues';
		priority: 30;
		items: [ (GhSession getArray: 'search/issues?q=author:' , self userName of: GhIssue sortKey: #updatedAt ) select: [ :each | each state = 'open' ]
		];
		column: 'Updated' text: #updatedAt;
		column: 'Title' text: #title
]

{ #category : 'accessing' }
GhUser >> gtReposFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Repositories';
		priority: 40;
		items: [ self repos ];
		send: [ :each | GhNode new data: each ];
		column: 'Repo' text: [ :each | each at: #name ];
		column: 'Description' text: [ :each | each at: #description ];
		column: 'Open issues' text: [ :each | each at: #open_issues_count ]
]

{ #category : 'accessing' }
GhUser >> repos [
	^ (GhSession getArray: 'user/repos')
		sorted: [ :a :b | (a at: #name) asLowercase < (b at: #name) asLowercase ]
]

{ #category : 'accessing' }
GhUser >> titleForBuilder: builder [
	^ data at: #login
]

{ #category : 'accessing' }
GhUser >> userName [
	^ data at: #login
]
