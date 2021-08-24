Extension { #name : 'LeLogicalDatabaseProperties' }

{ #category : '*CodingLog' }
LeLogicalDatabaseProperties >> isDirectoryRegistered: aFileReference [ 
	^ ((self registeredDatabaseDirectories collect: #resolve) includes: aFileReference asFileReference resolve)
]
