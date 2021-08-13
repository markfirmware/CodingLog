Class {
	#name : 'CodingLogShow',
	#superclass : 'Object',
	#category : 'CodingLog'
}

{ #category : 'accessing' }
CodingLogShow >> codingLoggerInstance [
	"view the log"
	CodingLogger instance
]

{ #category : 'accessing' }
CodingLogShow >> codingLoggerSaveRecordings [
	"save your log in the
savedRecordingsSton method which allows
the log to be saved under source control"
	CodingLogger saveRecordings
]

{ #category : 'accessing' }
CodingLogShow >> methodsSlideFor: aSlide [
	<gtSlide>
	^ aSlide labelAndElement
		priority: 20;
		newFadedText: 'The Methods view shows a sorted list of the methods that have been expanded';
		element: [ 
			GtPlaygroundLiveSlide new
				newSnippetFromMethod: self class>>#codingLoggerInstance
		]
]

{ #category : 'accessing' }
CodingLogShow >> newsSlideFor: aSlide [
	<gtSlide>
	^ aSlide labelAndElement
		priority: 25;
		newFadedText: 'The News view shows a time line of the first time a method has been viewed';
		element: [ 
			GtPlaygroundLiveSlide new
				newSnippetFromMethod: self class>>#codingLoggerInstance
		]
]

{ #category : 'accessing' }
CodingLogShow >> recordingsSlideFor: aSlide [
	<gtSlide>
	^ aSlide labelAndElement
		priority: 10;
		newFadedText: 'The Recordings view shows the methods that have been expanded';
		element: [ 
			GtPlaygroundLiveSlide new
				newSnippetFromMethod: self class>>#codingLoggerInstance;
				newSnippetFromMethod: self class >> #someMethods
		]
]

{ #category : 'accessing' }
CodingLogShow >> saveRecordingsSlideFor: aSlide [
	<gtSlide>
	^ aSlide labelAndElement
		priority: 30;
		newFadedText: 'The log can be saved under source control';
		element: [ 
			GtPlaygroundLiveSlide new
				newSnippetFromMethod: self class>>#codingLoggerInstance;
				newSnippetFromMethod: self class >> #codingLoggerSaveRecordings
		]
]

{ #category : 'accessing' }
CodingLogShow >> someMethods [
	"inspect this then expand some
of the methods shown - re-inspect
the log (first snippet) and you
will see that the  expansions are
recorded under Recordings"
	#gtView gtPragmas & #list gtReferences
]

{ #category : 'accessing' }
CodingLogShow >> titleSlideFor: aSlide [
	<gtSlide>
	^ aSlide title
		priority: 1;
		titleWithFormat: ('The Coding Log' asRopedText
			fontSize: 50;
			bold;
			glamorousRegularFont);
		subtitleWithFormat: ('dx tool' asRopedText
			fontSize: 40;
			thin;
			glamorousRegularFont)
]
