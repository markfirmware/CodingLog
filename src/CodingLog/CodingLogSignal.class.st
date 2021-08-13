Class {
	#name : 'CodingLogSignal',
	#superclass : 'BeaconSignal',
	#category : 'CodingLog'
}

{ #category : 'accessing' }
CodingLogSignal >> isMethodSignal [
	^ false
]

{ #category : 'accessing' }
CodingLogSignal >> print [
	^ self properties at: #print
]

{ #category : 'accessing' }
CodingLogSignal >> print: aString [
	self properties at: #print put: aString
]

{ #category : 'accessing' }
CodingLogSignal >> printOneLineContentsOn: stream [
	stream nextPutAll: self print
]
