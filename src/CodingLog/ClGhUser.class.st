Class {
	#name : #ClGhUser,
	#superclass : #ClGhApiData,
	#category : 'CodingLog-GitHub'
}

{ #category : #accessing }
ClGhUser class >> current [
	^ self new data: (self get: 'user')
]

{ #category : #accessing }
ClGhUser >> gtDisplayRunOn: stream [
	| status |
	status := self rawData at: #status.
	stream
		nextPutAll: (self rawData at: #updated_at);
		nextPutAll: String space;
		nextPutAll: (status = 'completed' ifTrue: [(self rawData at: #conclusion)] ifFalse: [status])
]

{ #category : #accessing }
ClGhUser >> gtDisplayString [
	^ self login
]

{ #category : #accessing }
ClGhUser >> gtEventsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Events';
		priority: 20;
		send: [ :each | ClGhApiData new data: each ];
		items: [
			((self class getArray: 'users/' , self login , '/events') select: [ :each |
				(each at: #payload at: #action ifAbsent: [ '' ]) ~= 'closed'
			]) sorted: [ :a : b |
				(a at: #created_at) > (b at: #created_at)
			]
		];
		column: 'Created' text: [ :each | (each at: #created_at) asDateAndTime asLocal ];
		column: 'Type' text: [ :each | each at: #type ];
		column: 'Actor' text: [ :each | each at: #actor at: #display_login ]
]

{ #category : #accessing }
ClGhUser >> gtNotificationsFor: aView [
	<gtView>
	^ aView list
		title: 'Notifications';
		priority: 10;
		actionUpdateButton;
		items: [
			self class purge: 'notifications'.
			self class getArray: 'notifications' of: ClGhNotification sortKey: #updatedAt
		]
]

{ #category : #accessing }
ClGhUser >> gtOpenIssuesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Issues';
		priority: 30;
		items: [ (self class getArray: 'search/issues?q=author:' , self login of: ClGhIssue sortKey: #updatedAt ) select: [ :each | each state = 'open' or: [ each updatedAt >= (DateAndTime today - 7 days) ] ]
		];
		column: 'Updated' text: #updatedAt;
		column: 'Title' text: #title
]

{ #category : #accessing }
ClGhUser >> gtReposFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Repositories';
		priority: 40;
		items: [ self repos ];
		send: [ :each | ClGhApiData new data: each ];
		column: 'Repo' text: [ :each | each at: #name ];
		column: 'Description' text: [ :each | each at: #description ];
		column: 'Open issues' text: [ :each | each at: #open_issues_count ]
]

{ #category : #accessing }
ClGhUser >> repos [
	^ (self class getArray: 'user/repos')
		sorted: [ :a :b | (a at: #name) asLowercase < (b at: #name) asLowercase ]
]
