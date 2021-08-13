Extension { #name : 'GtPharoMethodCoder' }

{ #category : '*CodingLog' }
GtPharoMethodCoder >> hideAddOnsFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 1>

	coderAddOns
		addMainAction: 'Hide' translated
		icon: BrGlamorousVectorIcons downwards
		action: [ :aCoderUIModel :anElement | CodingLogger instance hide: self sourceCode compiledMethod ];
		addMainAction: 'Unhide' translated
		icon: BrGlamorousVectorIcons upwards
		action: [ :aCoderUIModel :anElement | CodingLogger instance unhide: self sourceCode compiledMethod ]
]
