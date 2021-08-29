Class {
	#name : 'ClGhIssue',
	#superclass : 'ClGhApiData',
	#category : 'CodingLog-GitHub'
}

{ #category : 'accessing' }
ClGhIssue >> gtDisplayString [
	^ self title
]

{ #category : 'accessing' }
ClGhIssue >> gtOverviewFor: aView [
	<gtView>
	^ aView list
		title: 'Overview';
		priority: 50;
		items: [ | list |
			list := OrderedCollection new.
			list add: self title.
			list add: self body.
			list addAll: (((self class getArray: self commentsUrl) sorted: [ :a :b | (a at: #created_at) > (b at: #created_at) ]) collect: [ :each | each at: #body ]).
			list
		]
]
