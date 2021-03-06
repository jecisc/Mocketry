"
I am specification of expected object sender. I specify object which should be returned from one of occurred messages and I specify sender message which actualy should returned it.
 
My instance can be created by
	SpecOfExpectedObjectSender for: anObjectOrSpec returnedFrom: aSpecOfExpectedMessage
 
Internal Representation and Key Implementation Points.

    Instance Variables
	object:		<Object>
	requiredSender:	<SpecOfExpectedMessage>
"
Class {
	#name : #SpecOfExpectedObjectSender,
	#superclass : #SpecOfOccurredMessages,
	#instVars : [
		'object',
		'requiredSender'
	],
	#category : 'Mocketry-Specs'
}

{ #category : #'instance creation' }
SpecOfExpectedObjectSender class >> for: aString returnedFrom: aSpecOfExpectedMessage [ 
	^self new 
		object: aString;
		requiredSender: aSpecOfExpectedMessage 
]

{ #category : #converting }
SpecOfExpectedObjectSender >> asInteractionSpecBetweenConcreteObjectsOf: anInteractionHistory [

	| result returnedObjects concreteSenderSpec |
	object asStateSpec class == SpecOfIdentity ifTrue: [^self]. 
	result := SpecOfMultipleMessages new.
	
	returnedObjects := anInteractionHistory occurredMessages 
		select: [:each | each hasReturnedValueLike: object]
		thenCollect: [:each | each returnedValue ].
	returnedObjects do: [ :each | 
		concreteSenderSpec := self class for: each returnedFrom: requiredSender.
		result addExpectedMessage: concreteSenderSpec 
	].

	^result
]

{ #category : #testing }
SpecOfExpectedObjectSender >> basicMatches: occurredMessages [

	| actualSenders |
	actualSenders := occurredMessages select: [:each | each hasReturnedValueLike: object].
	
	^requiredSender basicMatches: actualSenders
]

{ #category : #printing }
SpecOfExpectedObjectSender >> description [
	^self printObject, ' should be returned from ', self printRequiredSender
]

{ #category : #accessing }
SpecOfExpectedObjectSender >> invertChildren [
	super invertChildren.
	 
	requiredSender invert
]

{ #category : #accessing }
SpecOfExpectedObjectSender >> object [
	^ object
]

{ #category : #accessing }
SpecOfExpectedObjectSender >> object: anObjectOrSpec [
	object := anObjectOrSpec asStateSpec
]

{ #category : #accessing }
SpecOfExpectedObjectSender >> populateMultipleMessagesSpec: aMultipleMessagesSpec [
	self shouldNotImplement 
]

{ #category : #printing }
SpecOfExpectedObjectSender >> printObject [
	^object printSimpleValue 
]

{ #category : #printing }
SpecOfExpectedObjectSender >> printRequiredSender [
	^requiredSender printMessageSend
]

{ #category : #accessing }
SpecOfExpectedObjectSender >> requiredSender [
	^ requiredSender
]

{ #category : #accessing }
SpecOfExpectedObjectSender >> requiredSender: anObject [
	requiredSender := anObject
]

{ #category : #validation }
SpecOfExpectedObjectSender >> validate: occurredMessages [
	| actualSenders result |
	actualSenders := occurredMessages	select: [ :each | each hasReturnedValueLike: object ].
	actualSenders ifEmpty: [ ^ self validateRequiredSenderFor: occurredMessages ].
	
	result := requiredSender validate: actualSenders.
	result isSuccess ifTrue: [ ^ result ].
	
	^ SpecOfWrongObjectSender spec: self for: occurredMessages wrongSender: actualSenders last
]

{ #category : #validation }
SpecOfExpectedObjectSender >> validateRequiredSenderFor: occurredMessages [
	| result |
	result := requiredSender validate: occurredMessages.
	result isSuccess ifTrue: [ 
		result := (SpecOfMessageReturnedValue requiredValue: object)
			validate: result occurredMessages last ].
	
	result isSuccess ifTrue: [ ^result ].
	
	^SpecOfWrongObjectSender spec: self for: occurredMessages
]
