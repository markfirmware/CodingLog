Class {
	#name : #GtHomeCodingLogSection,
	#superclass : #GtHomeSection,
	#category : #CodingLog
}

{ #category : #accessing }
GtHomeCodingLogSection >> create [
	| sectionContainer cardsContainer |
	sectionContainer := self newSectionContainer.
	sectionContainer addChild: (self newSectionTitle: 'Coding Log').
	cardsContainer := self newCardsContainer.
	cardsContainer addChild: (self
		newShowCardWithTitle: 'The Coding Log'
		slideshow: [ GtLiveShow createWithArrowsVisible: CodingLogShow new ]
		description: 'Keep track of your coding effort').
	sectionContainer addChild: cardsContainer.
	^ sectionContainer
]
