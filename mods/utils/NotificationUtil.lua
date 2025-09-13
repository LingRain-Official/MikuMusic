require "env"
local Intent = luajava.bindClass "android.content.Intent"
local Context = luajava.bindClass "android.content.Context"
local Notification = luajava.bindClass "android.app.Notification"
local PlaybackState = luajava.bindClass "android.media.session.PlaybackState"
local PendingIntent = luajava.bindClass "android.app.PendingIntent"
--MediaSession = luajava.bindClass "android.media.session.MediaSession"
local Bundle = luajava.bindClass "android.os.Bundle"
local _M = {}
local Glide = luajava.bindClass "com.bumptech.glide.Glide"
local CustomTarget = luajava.bindClass "com.bumptech.glide.request.target.CustomTarget"
local IconDrawable = require "mods.utils.IconDrawable"
local Build = luajava.bindClass "android.os.Build"
function imgdr(name)
  local Icon = luajava.bindClass"android.graphics.drawable.Icon"
  local icon = activity.getLuaDir().. "/res/drawable/"..name
  Glide.with(this)
  .asBitmap()
  .load(icon)
  .override(72, 72)--这里是为了适应大小，但用Glide有个弊端就是没法一下子加载，所以首次进入会报错，我也不知道怎么解决。。。(/"≡ _ ≡)=
  .into(CustomTarget{
    onResourceReady = function(resource, transition)
      icon = Icon.createWithBitmap(resource)
    end
  })
  return icon
end

function _M.updateNotification()

  if currentBitmap and currentBitmap.isRecycled() then
    return
  end
  notificationBuilder = Notification.Builder(activity, CHANNEL_ID)
  -- 创建PendingIntent
  local function createPendingIntent(action)
    local intent = Intent(action)
    intent.setPackage(activity.getPackageName()) -- 限制只在本应用内接收
    if Build.VERSION.SDK_INT >= 31 then
      return PendingIntent.getBroadcast(this, 0, intent, PendingIntent.FLAG_IMMUTABLE)
     else
      return PendingIntent.getBroadcast(this, 0, intent, PendingIntent.FLAG_ONE_SHOT)
    end
  end
  notificationBuilder
  .setSmallIcon(R.drawable.icon)
  .setContentTitle(name)
  .setContentText(artist)
  .setLargeIcon(currentBitmap)
  .setOngoing(mediaPlayer.isPlaying())
  .setPriority(Notification.PRIORITY_HIGH)
  .setStyle(Notification.MediaStyle()
  .setMediaSession(mediaSession.getSessionToken())
  .setShowActionsInCompactView({0, 1, 2}))
  .addAction(android.R.drawable.ic_media_previous, "上一首", createPendingIntent("PREV"))
  .addAction(mediaPlayer.isPlaying() and android.R.drawable.ic_media_pause or android.R.drawable.ic_media_play, mediaPlayer.isPlaying() and "暂停" or "播放", createPendingIntent("PLAY"))
  .addAction(android.R.drawable.ic_media_next, "下一首", createPendingIntent("NEXT"))
  notificationManager = activity.getSystemService(Context.NOTIFICATION_SERVICE)
  notificationManager.notify(NOTIFICATION_ID, notificationBuilder.build())
end
function _M.updatePlaybackState()
  if not mediaPlayer then
    return
  end
  state = mediaPlayer.isPlaying() and PlaybackState.STATE_PLAYING or PlaybackState.STATE_PAUSED
  actions = PlaybackState.ACTION_PLAY |
  PlaybackState.ACTION_PAUSE |
  PlaybackState.ACTION_SKIP_TO_NEXT |
  PlaybackState.ACTION_SEEK_TO

  mediaSession.setPlaybackState(PlaybackState.Builder()
  .setState(state, mediaPlayer.getCurrentPosition(), 1.0)
  .setActions(actions)
  .build())

end
return _M