Extension { #name : 'GhRepo' }

{ #category : '*CodingLog' }
GhRepo >> gtWorkflowRunsFor: aView [
	<gtView>
	^ aView list
		title: 'Runs';
		priority: 10;
		items: [ self workflowRuns ]
]

{ #category : '*CodingLog' }
GhRepo >> gtWorkflowsFor: aView [
	<gtView>
	^ aView list
		title: 'Workflows';
		priority: 10;
		items: [ self workflows ]
]

{ #category : '*CodingLog' }
GhRepo >> workflows [
	^ GhUnknownGroup new rawData: ((GhSession create: GhUnknownEntity from: (rawData at: #url) , '/actions/workflows') rawData at: #workflows)
]
