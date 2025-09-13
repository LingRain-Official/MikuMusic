local _M = {}
--[==[
666再也不写屎山了
重构你得重构一辈子还不如重写
这个切歌逻辑不一样
调用直接帮你播放了
]==]
local AudioManager = luajava.bindClass "android.media.AudioManager"
local MusicData = require "mods.utils.MusicData"
local Music = require "mods.utils.MusicModule"
local NotificationUtil = require "mods.utils.NotificationUtil"
local http = require "http"
local Glide = luajava.bindClass "com.bumptech.glide.Glide"
local CustomTarget = luajava.bindClass "com.bumptech.glide.request.target.CustomTarget"
local MediaMetadata = luajava.bindClass "android.media.MediaMetadata"
function _M.MusicPlay(url)
  if mediaPlayer then
    mediaPlayer.stop()
    mediaPlayer.release()
    mediaPlayer = nil
  end
  if ti2 then
    ti2.stop()
    ti2 = nil
  end
  MusicSlider.setValue(0)
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
      local duration = mp.getDuration()
      mp.start()

      MusicSlider.setEnabled(true)

      Glide.with(activity.getApplicationContext()).load(activity.getLuaDir() .. "/res/drawable/stop.png").into(playbtn)

      endtime.Text = Music.msTotime(duration)

      MusicSlider.setValueTo(duration)

      MusicSlider.setValueFrom(0)

      isPrepared = true

      paused = false

      Http.get("https://y.music.163.com/m/song?id=" .. id, function(code, content)
        if code == 200 then
          pic = string.match(content, '<meta property="og:image" content="(.-)" />')
          name, artist = string.match(content, '<meta property="og:title" content="(.-) %- (.-) %- .- %- 网易云音乐" />')
          Glide.with(this).asBitmap().load(pic).into(CustomTarget {
            onResourceReady = function(bitmap)
              currentBitmap = bitmap
              mediaSession.setMetadata(MediaMetadata.Builder()
              .putString(MediaMetadata.METADATA_KEY_TITLE, name)
              .putString(MediaMetadata.METADATA_KEY_ARTIST, artist)
              .putLong(MediaMetadata.METADATA_KEY_DURATION, duration)
              .putBitmap(MediaMetadata.METADATA_KEY_ALBUM_ART, currentBitmap)
              .build())
              NotificationUtil.updatePlaybackState()
              NotificationUtil.updateNotification()
            end
          })
        end
      end)
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
        currenttime.Text = Music.msTotime(currentposition)
        MusicSlider.setValue(currentposition)
        lrcview.updateTime(mediaPlayer.getCurrentPosition())
      end
    end
  end
  ti2.start()
end

function _M.nextMusic()

  local musicList = p_list
  max = #musicList
  sequence = sequence + 1
  if sequence > max then
    sequence = 1
    --直接快捷更新所有需要更新的内容
    id = p_list[sequence]
    Music.loadLyric(id)
    Music.loadCover(id, img3)
    _M.MusicPlay(MusicData.getMusicRes(id))
   else
    id = p_list[sequence]
    Music.loadLyric(id)
    Music.loadCover(id, img3)
    _M.MusicPlay(MusicData.getMusicRes(id))
  end
end

function _M.lastMusic()

  local musicList = p_list

  sequence = sequence - 1
  if sequence == 0 then
    --越出索引范围，返回最后一首
    --如果是本地音乐，将musicList[#musicList].id替换为路径
    sequence = #musicList
    id = p_list[sequence]
    Music.loadLyric(id)
    Music.loadCover(id, img3)
    _M.MusicPlay(MusicData.getMusicRes(id))
   else
    id = p_list[sequence]
    Music.loadLyric(id)
    Music.loadCover(id, img3)
    _M.MusicPlay(MusicData.getMusicRes(id))
  end
end

return _M