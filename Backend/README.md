# Pomoc Backend

## Server
### Setup
1. `npm install`
2. `cp settings_local.js.dist settings_local.js`
3. Modify settings_local.js for your local environment

### Start
1. `node app.js`

### Web page testing
1. app page will be on localhost:3217
2. subscribe to a channel
3. you will be able to receive and send messages to others on the same channel

### TODO
- Database schema
- Vendor app chat logic - need an efficient way of getting messages and handling multiple chats. (non-efficient way is also acceptable lols)
- Need to find efficient way of getting past messages
- Authentication
- Handling of subscription and unsubscription of Redis - should be more efficient but we can ignore this if it is too much of a hassle.

### Reference
Reference: http://garydengblog.wordpress.com/2013/06/28/simple-chat-application-using-redis-socket-io-and-node-js/comment-page-1/

## Testing iOS App
### SocketRocket dependent frameworks:
- libicucore.dylib
- CFNetwork.framework
- Security.framework
- Foundation.framework

### How to use
- start app
- set channel
- start chatting
- able to chat with test webapp on the same channel: http://localhost:3217/
