# Backend Server
## Dependencies
- Redis server
- Node

## How to start server
- execute script `./start`
- if not able to execute `start` file, run command `chmod 700 start` and try again.

## Schema
Keys | Values| Description
--- | --- | ---
`<channelId>:chat` | `[{username:xxx, channel:yyy, message:ddd, timestamp:ttt, type:{chat, subscribe, unsubscribe}}, ...]` | ordered set of messages scored by timestamp
`<channelId>:party` | `{mun, soe, ste, ban, ...}`| set of users subscribed to the channel
`<username>:sub` | `{channel1, channel2, channel3, ...}`| set of channels user is subscribed to
`<appId>:notification` | `{channel1, channel2, channel3, ...}`| app channel where support staff receive notifications

### Message Format
`{
    message: xxx,
    type: ttt,
    timestamp: qqq,
    username: uuu,
    channel: ccc
}`

## Flow
### New chat
- User initiates chat
- User gets subscribed to chat
- App's support staff gets notified about new channel through app's
  notification channel
- After receiving notification, a subscription message from the support's staff
  client app is sent to the server
- Server subscribes staff to the new channel
### Resubscribing to existing channel
- Support's staff client app does a http get call to `get_chat/<username>` to
  get all previous messages in chat channel
- After which, the client app would send a subscription message to subscribe to
  the chat channel
- Server subscribes staff to channel
### Unsubscribing from a channel
- Unsubscription message sent to server
- Server unsubscribes staff from channel
- Staff will not receive new messages from channel unless he/she subscribes
  back to the channel
