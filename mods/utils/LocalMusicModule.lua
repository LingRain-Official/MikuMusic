local _M = {}
local AudioManager = luajava.bindClass "android.media.AudioManager"
local CustomTarget = luajava.bindClass "com.bumptech.glide.request.target.CustomTarget"
local Ticker = luajava.bindClass "com.androlua.Ticker"
local Glide = luajava.bindClass "com.bumptech.glide.Glide"
local MediaMetadata = luajava.bindClass "android.media.MediaMetadata"
local MediaPlayer = luajava.bindClass "android.media.MediaPlayer"
local MediaMetadataRetriever = luajava.bindClass "android.media.MediaMetadataRetriever"
local BitmapFactory = luajava.bindClass "android.graphics.BitmapFactory"
local NotificationUtil = require "mods.utils.NotificationUtil"
local Music = require "mods.utils.MusicModule"

function _M.msTotime(t)
  local s = t / 1000
  local sec = tointeger(s % 60)
  if sec < 10 then
    sec = "0" .. sec
  end
  local min = tointeger(s // 60)
  if min < 10 then
    min = "0" .. min
  end
  return min .. ":" .. sec
end

function _M.LocalMusicPlay(url)
  if mediaPlayer then
    mediaPlayer.stop()
    mediaPlayer.release()
    mediaPlayer = nil
  end
  if ti2 then
    ti2.stop()
    ti2 = nil
  end
  local MediaPlayer = luajava.bindClass "android.media.MediaPlayer"
  mediaPlayer = MediaPlayer()
  local success, err = pcall(function()
    mediaPlayer.reset()
    mediaPlayer.setDataSource(url)
    mediaPlayer.prepareAsync()
  end)
  if not success then
    traceback("设置数据源失败: " .. err)
    return
   else

    local retriever = MediaMetadataRetriever()
    retriever.setDataSource(url)
    local coverBytes = retriever.getEmbeddedPicture()
    if coverBytes then
      coverBitmap = BitmapFactory.decodeByteArray(coverBytes, 0, #coverBytes)
      currentBitmap = coverBitmap
     else
      coverBitmap = loadbitmap(activity.getLuaDir().."/res/image/background.jpg")
    end
    task(500, function()
      Glide.with(activity.getApplicationContext())
      .load(coverBitmap)
      .into(img3)
    end)
  end
  isPrepared = false
  mediaPlayer.setOnErrorListener(MediaPlayer.OnErrorListener{
    onError = function(mp, what, extra)
      print(what .. " " .. extra)
      MusicSlider.setEnabled(false)
      playbtn.setEnabled(false)
      return true
    end
  })

  mediaPlayer.setScreenOnWhilePlaying(true)
  mediaPlayer.setOnPreparedListener(MediaPlayer.OnPreparedListener{
    onPrepared = function(mp)
      duration = mp.getDuration()
      mp.start()

      MusicSlider.setEnabled(true)

      Glide.with(activity.getApplicationContext()).load(activity.getLuaDir() .. "/res/drawable/stop.png").into(playbtn)

      endtime.Text = _M.msTotime(duration)

      MusicSlider.setValueTo(duration)

      isPrepared = true

      paused = false

      mediaSession.setMetadata(MediaMetadata.Builder()
      .putString(MediaMetadata.METADATA_KEY_TITLE, name)
      .putString(MediaMetadata.METADATA_KEY_ARTIST, artist)
      .putLong(MediaMetadata.METADATA_KEY_DURATION, duration)
      .putBitmap(MediaMetadata.METADATA_KEY_ALBUM_ART, coverBitmap)
      .build())
      NotificationUtil.updatePlaybackState()
      NotificationUtil.updateNotification()
    end
  })
  AutoNext()
  if result == AudioManager.AUDIOFOCUS_REQUEST_GRANTED then
   else
    if not paused
      Music.autoPausePlay()
    end
  end
  ti2 = Ticker()
  ti2.Period = 500
  ti2.onTick = function()

    if mediaPlayer and isPrepared and mediaPlayer.isPlaying() then
      if not isSeekbarTracking then
        currentposition = mediaPlayer.getCurrentPosition()
        currenttime.Text = _M.msTotime(currentposition)
        MusicSlider.setValue(currentposition)
      end
    end
  end
  ti2.start()
end
return _M