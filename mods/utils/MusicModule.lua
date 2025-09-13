require "env"
local _M = {}
local MediaPlayer = luajava.bindClass "android.media.MediaPlayer"
local Glide = luajava.bindClass "com.bumptech.glide.Glide"
local ObjectAnimator = luajava.bindClass "android.animation.ObjectAnimator"
local MotionEvent = luajava.bindClass "android.view.MotionEvent"
local json = require "json"
local NotificationUtil = require "mods.utils.NotificationUtil"
local MediaMetadata = luajava.bindClass "android.media.MediaMetadata"
local CustomTarget = luajava.bindClass "com.bumptech.glide.request.target.CustomTarget"
local AudioManager = luajava.bindClass "android.media.AudioManager"
local DiskCacheStrategy = luajava.bindClass "com.bumptech.glide.load.engine.DiskCacheStrategy"
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

function _M.autoPausePlay()
  if mediaPlayer then
    if mediaPlayer.isPlaying() then
      paused = true
      mediaPlayer.pause()
      Glide.with(activity.getApplicationContext()).load(activity.getLuaDir() .. "/res/drawable/bofang.png").into(playbtn)
     else
      paused = false
      mediaPlayer.start()
      Glide.with(activity.getApplicationContext()).load(activity.getLuaDir() .. "/res/drawable/stop.png").into(playbtn)
    end
   else
    traceback("没有找到mediaPlayer对象")
  end
end

function _M.loadCover(id, view)
  Http.get("https://y.music.163.com/m/song?id=" .. id, function(code, content)
    if code == 200 then
      pic = string.match(content, '<meta property="og:image" content="(.-)" />')
      coverUrl = pic
      Glide.with(activity.getApplicationContext())
      .load(pic)
      .into(view)
      Glide.with(this).asBitmap().load(pic).into(CustomTarget {
        onResourceReady = function(bitmap)
          currentBitmap = bitmap
          NotificationUtil.updateNotification()
        end
      })

    end
  end)
end

function _M.getCover(ids, callback)
  Http.get("https://y.music.163.com/m/song?id=" .. ids, function(code, content)
    if code == 200 then
      local pic = string.match(content, '<meta property="og:image" content="(.-)" />')
      callback(pic)
    end
  end)
end

function _M.setButtonBounce(view, size, time)
  local size = size or 0.9
  local time = time or 100
  view.OnTouchListener = function(View, Event)
    if Event.getAction() == MotionEvent.ACTION_DOWN then
      ObjectAnimator().ofFloat(view, "scaleX", {1, size}).setDuration(time).start()
      ObjectAnimator().ofFloat(view, "scaleY", {1, size}).setDuration(time).start()
     elseif Event.getAction() == MotionEvent.ACTION_UP then
      ObjectAnimator().ofFloat(view, "scaleX", {size, 1}).setDuration(time).start()
      ObjectAnimator().ofFloat(view, "scaleY", {size, 1}).setDuration(time).start()
    end
  end
end


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
  --MusicSlider.setValue(0)
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
      duration = mp.getDuration()
      mp.start()

      Glide.with(activity.getApplicationContext()).load(activity.getLuaDir() .. "/res/drawable/stop.png").into(playbtn)

      endtime.Text = _M.msTotime(duration)

      MusicSlider.setValueTo(duration)

      MusicSlider.setValueFrom(0)

      AutoNext()
      
      MusicSlider.setEnabled(true)
      playbtn.setEnabled(true)
      
      isPrepared = true

      paused = false

      Http.get("https://y.music.163.com/m/song?id=" .. id, function(code, content)
        if code == 200 then
          pic = string.match(content, '<meta property="og:image" content="(.-)" />')
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
  if result == AudioManager.AUDIOFOCUS_REQUEST_GRANTED then
   else
    if not paused
      _M.autoPausePlay()
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
        lrcview.updateTime(mediaPlayer.getCurrentPosition())
      end
    end
  end
  ti2.start()
end

function _M.setLyric(lrc, lrcen)
  lrcview.loadLrc(lrc, lrcen)
  lrcview.setLabel("歌词加载中..\n本地音乐暂不支持读取歌词")
  lrcview.setDividerHeight(lrcview.convertToPixels("DP", 10))
  -- 设置当前歌词文本字体大小
  lrcview.setCurrentTextSize(lrcview.convertToPixels("SP", 18))
  -- 设置其它歌词字体大小
  lrcview.setNormalTextSize(lrcview.convertToPixels("SP", 16))
  -- 设置歌词两侧距离
  lrcview.setLrcPadding(lrcview.convertToPixels("DP", 50))
  lrcview.setOnTapListener(function(view, x, y)
  end)
end

function _M.loadLyric(id163)
  Http.get("http://music.163.com/api/song/lyric?id=" .. id163 .. "&lv=4&kv=-1&tv=-1", function(code, content)
    if code == 200 then
      if pcall(function()
        end)
        local lrcbody = json.decode(content)
        local lrc = lrcbody.lrc.lyric
        if #lrc > 1 then
          --lrcview.setPicture(activity.getLuaDir().."/res/musiclist.png")
          if pcall(function()
              if lrcbody.tlyric.lyric then
                local lrcen = lrcbody.tlyric.lyric
                _M.setLyric(lrc, lrcen)
               else
                _M.setLyric(lrc, _)
              end
            end)
           else
            _M.setLyric(lrc, _)
          end
         elseif #lrc < 1 then
          Http.get("http://music.163.com/api/song/lyric?id=" .. id163 .. "&lv=1&kv=1&tv=-1", function(code, content)
            local lrcbody = json.decode(content)
            local lrc = lrcbody.tlyric.lyric
            local lrcen = lrcbody.lrc.lyric
            _M.setLyric(lrc, lrcen)
          end)
        end
       else
      end
    end
  end)
end
return _M