# Server Test
Reference: http://garydengblog.wordpress.com/2013/06/28/simple-chat-application-using-redis-socket-io-and-node-js/comment-page-1/
## Running the app - server
1. download and install npm and redis 
2. in this folder (server/) run `npm install` to install dependencies listed in
package.json
3. run the app - `npm app.js`
 
## Using the client - web page (testing)
1. app page will be on localhost:8000
2. subscribe to a channel
3. you will be able to receive and send messages to others on the same channel

## TODO
- Database schema
- Vendor app chat logic - need an efficient way of getting messages and handling multiple chats. (non-efficient way is also acceptable lols)
- Need to find efficient way of getting past messages
- Authentication
- Handling of subscription and unsubscription of Redis - should be more efficient but we can ignore this if it is too much of a hassle.
