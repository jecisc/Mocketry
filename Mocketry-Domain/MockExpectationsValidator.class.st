"
I am helper object which uses expected messages to create spec and validate tested block.
 
I drive following should expressions: 

	[  ""tested behaviour""  ] should lenient satisfy: [ ""expectations"" ]
	[  ""tested behaviour""  ] should strictly satisfy: [ ""expectations"" ]

My interactionSpec variable should contains specific kind of SpecOfObjectsInteraction spec to provide different kind of validation.

#lenient message will create me with simple SpecOfObjectsInteraction spec which will only verify that all expected messages was really occurred.

#strictly message will create me with SpecOfOrderedObjectsInteraction spec which wil verify that expected messages was occurred in same order as defined.

Public API and Key Messages

- satisfy: aBlock 
It will teach mocks for expected behaviour defined by given aBlock. And then it will verify that during verifiedBlock all expectations was occurred.

Internal Representation and Key Implementation Points.

    Instance Variables
	interactionSpec:		<SpecOfObjectsInteraction>
	verifiedBlock:		<BlockClosure>
"
Class {
	#name : #MockExpectationsValidator,
	#superclass : #Object,
	#instVars : [
		'interactionSpec',
		'shouldExpression'
	],
	#category : #'Mocketry-Domain'
}

{ #category : #'instance creation' }
MockExpectationsValidator class >> for: aShouldExpression by: aMultipleMessagesSpec [

	^self new 
		shouldExpression: aShouldExpression;
		interactionSpec: aMultipleMessagesSpec
]

{ #category : #accessing }
MockExpectationsValidator >> interactionSpec [
	^ interactionSpec
]

{ #category : #accessing }
MockExpectationsValidator >> interactionSpec: anObject [
	interactionSpec := anObject
]

{ #category : #validation }
MockExpectationsValidator >> satisfy: blockWithExpectations [

	| teacher |
	teacher := MockValidatedExpectationsTeacher new.
	MockCurrentBehaviour useMockRole: teacher while: blockWithExpectations.
	
	shouldExpression receiver value value.
	interactionSpec expectedMessages: teacher convertExpectationsToSpecs.
	^shouldExpression evaluateWith: interactionSpec forMockBehaviour: MockCurrentBehaviour value.
]

{ #category : #accessing }
MockExpectationsValidator >> shouldExpression [
	^ shouldExpression
]

{ #category : #accessing }
MockExpectationsValidator >> shouldExpression: anObject [
	shouldExpression := anObject
]
