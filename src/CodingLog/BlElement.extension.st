Extension { #name : 'BlElement' }

{ #category : '*CodingLog' }
BlElement >> codingLogActions: sum on: it [
	it isVisible ifFalse: [ ^ sum ].
	it children do: [ :each |
		(each isKindOf: BrButton) ifTrue: [ | m |
			m := (each userData at: #brickViewModel ifAbsent: [ nil ]).
			m notNil ifTrue: [
				(m action class == BlockClosure and: [ m action outerContext ~= nil ]) ifTrue: [ | vars |
					vars := m action outerContext gtVariables.
					vars do: [ :v | (self isCodingLogAction: v value) ifTrue: [ sum add: v value ] ]
				]
			]
		].
		self codingLogActions: sum on: each
	].
	^ sum
]

{ #category : '*CodingLog' }
BlElement >> gtCodingLogActionsFor: aView [
	<gtView>
	^ aView list
		title: 'Actions';
		priority: 7;
		items: [ self codingLogActions: OrderedCollection new on: self ]
]

{ #category : '*CodingLog' }
BlElement >> isCodingLogAction: x [
	^ (x isKindOf: GtCoderAction) | (x isKindOf: GtPhlowAction)
]
