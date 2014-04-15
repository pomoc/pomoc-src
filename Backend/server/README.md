# Backend Server
## Dependencies
- Redis server
- Node

## Messages
There are 3 types of messages
### internalMessage
--------------------
#### newConversation
Creates a new conversation. conversationId gets created and sent back to user.
Agents of the application receive a message on event `newConversation`
containing the conversationId of the newly created conversation.

#### observeConversationList
Subscribes to the app's channel that will broadcast notifications of new
conversations

#### joinConversation
Joins a conversation. Upon doing so, users' online presence will be announced
to all the other parties in the conversation on the event `onlineStatus`. A
reply containing a **log of previous messages** for that conversation will be
sent back.

#### getConversationList
Returns a list of conversationIds that the user is a participant of.

#### getAppConversationList
Returns a list of conversationIds for the app.

#### getConversationLog
Returns the messages for the given conversationId.

#### getAppUsers
Returns the userIds of all the agents for the app.

### chatMessage
---------------
broadcasts to the conversationId channel whatever is received.

### applicationMessage
--------------------
#### handle
Adds the agent to the list of handlers for the given conversationId. 
Broadcasts the new list of handlers on the event `handlerStatus` to all
participants in given conversationId.

#### unhandle
Removes the agent from the list of handlers for the given conversationId.
Broadcasts the new list of handlers on the event `handlerStatus` to all
participants in given conversationId.

#### referHandler
Adds the referred agent to the list of handlers for the given conversationId.
Broadcasts the new list of handlers on event `handlerStatus` to all
participants in given conversationId.

#### getHandlers
Returns a list of handlers' userId for the given conversationId.
