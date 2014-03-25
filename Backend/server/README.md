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
`<channelId>:chat` | `[{username:xxx, channel:yyy, message:ddd, type:{chat, subscribe, unsubscribe}}, ...]` | ordered set of messages scored by timestamp
`<channelId>:party` | `{mun, soe, ste, ban, ...}`| set of users subscribed to the channel
`<username>:sub` | `{channel1, channel2, channel3, ...}`| set of channels user is subscribed to
`<appId>:notification` | `{channel1, channel2, channel3, ...}`| set of channels user is subscribed to
