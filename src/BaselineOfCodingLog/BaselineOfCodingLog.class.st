Class {
	#name : #BaselineOfCodingLog,
	#superclass : #BaselineOf,
	#category : #BaselineOfCodingLog
}

{ #category : #accessing }
BaselineOfCodingLog >> baseline: spec [
	<baseline>
	spec for: #common do: [ spec package: 'CodingLog' ]
]

{ #category : #accessing }
BaselineOfCodingLog >> projectClass [
	^ MetacelloCypressBaselineProject
]
