Class {
	#name : #ClPatches,
	#superclass : #Object,
	#classVars : [
		'isApplied'
	],
	#category : 'CodingLog-Patches'
}

{ #category : #accessing }
ClPatches class >> applyPatches [
	self patchClassesWithPatches: { CodingLogGtTextualCoderViewModel . ClGt4Git }.
]

{ #category : #accessing }
ClPatches class >> initialize [
	super initialize.
	isApplied := false
]

{ #category : #accessing }
ClPatches class >> patchClassesWithPatches: classesWithPatches [
	| withClassSideToo |
	withClassSideToo := classesWithPatches , (classesWithPatches collect: [ :each | each class ]).
	withClassSideToo do: [ :classWithPatches | | classWithStatusQuo classToPatch |
		classWithStatusQuo := classWithPatches superclass.
		classToPatch := classWithStatusQuo superclass.
		classWithPatches methods do: [ :method | | selector |
			selector := method selector.
    		(classToPatch >> selector) sourceCode = (classWithStatusQuo >> selector) sourceCode ifFalse: [
    			^ self
    		]
    	].
		classWithPatches methods do: [ :method | | selector |
			selector := method selector.
    		classToPatch compile: (classWithPatches >> selector) sourceCode
    	]
    ]
]
