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
- user initiates chat
- user gets subscribed to chat
- app's support staff gets notified about new channel through app's
  notification channel
- after receiving notification, a subscription message from the support's staff
  client app is sent to the server
- server subscribes staff to the new channel
