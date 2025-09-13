require "env"
local LinearLayoutManager = luajava.bindClass "androidx.recyclerview.widget.LinearLayoutManager"
local Glide = luajava.bindClass "com.bumptech.glide.Glide"
local FragmentContainer = luajava.bindClass "androidx.fragment.app.FragmentContainer"
local LuaFragment = luajava.bindClass "com.androlua.LuaFragment"
local LinearLayoutManager = luajava.bindClass "androidx.recyclerview.widget.LinearLayoutManager"
local LuaCustRecyclerAdapter = luajava.bindClass "com.lua.custrecycleradapter.LuaCustRecyclerAdapter"
local AdapterCreator = luajava.bindClass "com.lua.custrecycleradapter.AdapterCreator"
local LuaCustRecyclerHolder = luajava.bindClass "com.lua.custrecycleradapter.LuaCustRecyclerHolder"
local TransitionManager = luajava.bindClass "androidx.transition.TransitionManager"
local AutoTransition = luajava.bindClass "androidx.transition.AutoTransition"
local ColorStateList = luajava.bindClass "android.content.res.ColorStateList"
local BottomSheetDialog = luajava.bindClass "com.google.android.material.bottomsheet.BottomSheetDialog"
local ActionBarDrawerToggle = luajava.bindClass "androidx.appcompat.app.ActionBarDrawerToggle"
local GradientDrawable = luajava.bindClass "android.graphics.drawable.GradientDrawable"
DrawerLayout = luajava.bindClass "androidx.drawerlayout.widget.DrawerLayout"
local PendingIntent = luajava.bindClass "android.app.PendingIntent"
local Intent = luajava.bindClass "android.content.Intent"
local BroadcastReceiver = luajava.bindClass "android.content.BroadcastReceiver"
local MediaSession = luajava.bindClass "android.media.session.MediaSession"
local Build = luajava.bindClass "android.os.Build"
local NotificationChannel = luajava.bindClass "android.app.NotificationChannel"
local IntentFilter = luajava.bindClass "android.content.IntentFilter"
local NotificationManager = luajava.bindClass "android.app.NotificationManager"
local Context = luajava.bindClass "android.content.Context"
local MaterialAlertDialogBuilder = luajava.bindClass "com.google.android.material.dialog.MaterialAlertDialogBuilder"
local MediaPlayer = luajava.bindClass "android.media.MediaPlayer"
local Uri = luajava.bindClass "android.net.Uri"
local json = require "json"
local FileDrawable = require "mods.utils.FileDrawable"
local Music = require "mods.utils.MusicModule"
local IconDrawable = require "mods.utils.IconDrawable"
local SettingLayUtil = require "mods.utils.SettingLayUtil"
local MyPopupMenu = require "mods.utils.MyPopupMenu"
local MusicData = require "mods.utils.MusicData"
local NotificationUtil = require "mods.utils.NotificationUtil"
local LocalMusic = require "mods.utils.LocalMusicModule"
local pMusic = require "mods.utils.pMusicModule"
local MyPopupMenu = require "mods.utils.MyPopupMenu"

nextMusic = MusicData.nextMusic
sequence = MusicData.getHistoryMusic().sequence
hisMusic = MusicData.getHistoryMusic()
musicList = MusicData.getMusicList()
name = hisMusic.name
artist = hisMusic.artist
id = hisMusic.id

isLocalMusic = false
isPMusic = false
isUserAdd = true
paused = false
CHANNEL_ID, NOTIFICATION_ID = "MikuMusic_Music", 1


if Build.VERSION.SDK_INT >= Build.VERSION_CODES.O then
  local channel = NotificationChannel(CHANNEL_ID, "MikuMusic", NotificationManager.IMPORTANCE_LOW)
  channel.setDescription("♬ MikuMusic通知栏音乐♬ ")
  notificationManager = activity.getSystemService(Context.NOTIFICATION_SERVICE)
  notificationManager.createNotificationChannel(channel)
end

mediaSession = MediaSession(activity, "MikuMusic_Service")
mediaSession.setFlags(MediaSession.FLAG_HANDLES_MEDIA_BUTTONS |
MediaSession.FLAG_HANDLES_TRANSPORT_CONTROLS);

import "android.media.session.MediaSession$Callback"

mediaSession.setCallback(Callback({
  onPlay = function()
    Music.autoPausePlay()
    NotificationUtil.updateNotification()
    NotificationUtil.updatePlaybackState()
  end,

  onPause = function()
    Music.autoPausePlay()
    NotificationUtil.updateNotification()
    NotificationUtil.updatePlaybackState()
  end,

  onSeekTo = function(pos)
    mediaPlayer.seekTo(pos)
    mediaPlayer.start()
  end,

  onSkipToNext = function()
    if isUserAdd then
      Music.MusicPlay(MusicData.nextMusic())
      NotificationUtil.updateNotification()
     elseif isLocalMusic then
      LocalMusic.LocalMusicPlay(MusicData.nextMusic())
      NotificationUtil.updateNotification()
     else
      pMusic.nextMusic()
      NotificationUtil.updateNotification()
      NotificationUtil.updatePlaybackState()
    end
  end,

  onSkipToPrevious = function()
    if isUserAdd then
      Music.MusicPlay(MusicData.lastMusic())
      NotificationUtil.updateNotification()
     elseif isLocalMusic then
      LocalMusic.LocalMusicPlay(MusicData.lastMusic())
      NotificationUtil.updateNotification()
     else
      pMusic.lastMusic()
      NotificationUtil.updateNotification()
      NotificationUtil.updatePlaybackState()
    end
  end,
}))

mediaSession.setActive(true);

receiver = luajava.override(BroadcastReceiver, {
  onReceive = function(super, context, intent)
    local action = intent.getAction()
    if action == "PLAY" then
      Music.autoPausePlay()
      NotificationUtil.updateNotification()
      NotificationUtil.updatePlaybackState()
     elseif action == "NEXT" then
      if isUserAdd then
        Music.MusicPlay(MusicData.nextMusic())
        NotificationUtil.updateNotification()
        NotificationUtil.updatePlaybackState()
       elseif isLocalMusic then
        LocalMusic.LocalMusicPlay(MusicData.lastMusic())
        NotificationUtil.updateNotification()
        NotificationUtil.updatePlaybackState()
       else
        pMusic.nextMusic()
        NotificationUtil.updateNotification()
        NotificationUtil.updatePlaybackState()
      end
     elseif action == "PREV" then
      if isUserAdd then
        Music.MusicPlay(MusicData.lastMusic())
        NotificationUtil.updateNotification()
        NotificationUtil.updatePlaybackState()
       elseif isLocalMusic then
        LocalMusic.LocalMusicPlay(MusicData.lastMusic())
        NotificationUtil.updateNotification()
        NotificationUtil.updatePlaybackState()
       else
        pMusic.lastMusic()
        NotificationUtil.updateNotification()
        NotificationUtil.updatePlaybackState()
      end
    end
  end
})
filter = IntentFilter()
filter.addAction("PLAY")
filter.addAction("NEXT")
filter.addAction("PREV")
activity.registerReceiver(receiver, filter)

--[==[
主播是人机所以代码写很人机，都是一些简单的代码
代码结构简单容易理解所以没有注释
有一个令我很不解的问题是为什么RecyclerView如果单独扔到一个页面里用Fragment切换到这个页面时会有卡顿
但是如果套在Tablayout中切换就不会卡了

回归正题

MikuMusic v1.4

Built with LuaAppX

Powered by AndroLua (https://github.com/mkottman/AndroLua)

Design by Material Design 3 (https://m3.material.io)

]==]

activity

.setContentView(loadlayout("res.layout.activity_main"))

.setSupportActionBar(toolbar)

.getSupportActionBar()

onCreateOptionsMenu = function(menu)
  menu.add("关于应用")
  .onMenuItemClick = function(menu)
    activity.newActivity("activity/AboutActivity/AboutActivity")
  end
  menu.add("加群")
  .onMenuItemClick = function(menu)
    local url="mqqapi://card/show_pslcard?src_type=internal&version=1&uin=1022720286&card_type=group&source=qrcode"
    activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
  end
  menu.add("支持作者")
  .onMenuItemClick = function(menu)
    local dialog = BottomSheetDialog(activity)
    dialog.setContentView(loadlayout("res.layout.dialog_uphold"))
    dialog.show()
  end
  menu.add("AddMusic")
  .setShowAsAction(1)
  .setIcon(IconDrawable(activity.getLuaDir() .. "/res/drawable/add.png")).setShowAsAction(1).setIconTintList(ColorStateList.valueOf(Colors.colorOnSurfaceVariant))
  .onMenuItemClick = function()
    local dialog = BottomSheetDialog(activity)
    dialog.setContentView(loadlayout("res.layout.dialog_addmusic"))
    dialog.show()
    add.onClick = function()
      dialog.dismiss()
      local id = MusicData.sltoid3(string.match(tostring(url163.Text), "https?://[%w/&=%.]+"))
      if id then
        MaterialToast("解析成功")
        pcall(func)
        local id = string.match(tostring(url163.Text), "id=(%d+)")
        if not id then
          local http = require "http"

          local _, _, _, h = http.get(string.match(tostring(url163.Text), "https?://[%w/&=%.]+"))
          id = string.match(h.location, "id=(%d+)")
          MusicData.addMusic(id)
          musicList = MusicData.getMusicList()
          task(500,function()
            activity.recreate()
          end)
        end
        --print(string.match(tostring(url163.Text), "https?://[%w/&=%.]+"))
       else
        MaterialToast("解析失败")
      end
    end
    --[==[addMusicList.onClick = function()

    end
    ]==]
  end
end

local bottombarData = {
  [0] = {
    title = "Home",
    icon = FileDrawable("res/drawable/home.png"),
  },
  [1] = {
    title = "Music",
    icon = FileDrawable("res/drawable/music.png"),
  },

  [2] = {
    title = "Setting",
    icon = FileDrawable("res/drawable/settings.png"),
  },
}
nowIndex = 1

local bottombarChecked = 0

bottombar.menu.add(0, 0, 0, "Home").setIcon(bottombarData[0].icon)
bottombar.menu.add(0, 1, 1, "Music").setIcon(bottombarData[1].icon)
bottombar.menu.add(0, 2, 2, "Setting").setIcon(bottombarData[2].icon)

fragmentManager = activity.getSupportFragmentManager()
local Fragments = {
  LuaFragment(loadlayout("res.layout.page_home")),
  LuaFragment(loadlayout("res.layout.page_musiclist")),
  LuaFragment(loadlayout("res.layout.page_setting")),
  LuaFragment(loadlayout("res.layout.page_music")),
}
Fragments[4].setRetainInstance(true)

fragmentManager.beginTransaction()
.add(FragmentContainers.getId(), Fragments[1])
.commit()
bottombar.setOnNavigationItemSelectedListener(BottomNavigationView.OnNavigationItemSelectedListener{
  onNavigationItemSelected = function(item)
    fragmentManager.beginTransaction().setCustomAnimations(MDC_R.anim.mtrl_bottom_sheet_slide_in, MDC_R.anim.mtrl_bottom_sheet_slide_out).replace(FragmentContainers.getId(), Fragments[item.getItemId() + 1]).commit()
    nowIndex = item.getItemId() + 1
    return true
  end
})

--local VOCALOID = require "activity.MainActivity.MainActivity$VOCALOID";
local localMusic = require "activity.MainActivity.MainActivity$LocalMusic";
local pMusicIndex = require "activity.MainActivity.MainActivity$p";
local SetBanner = require "activity.MainActivity.MainActivity$Banner"
local settingData = require "activity.MainActivity.MainActivitiy$SettingData"
function updataAdp()
  local adp = LuaCustRecyclerAdapter(AdapterCreator({
    getItemCount = function()
      return #musicList
    end,
    onCreateViewHolder = function(parent, viewType)
      local views = {}
      local holder = LuaCustRecyclerHolder(loadlayout("res.layout.item_musiclist", views))
      holder.view.setTag(views)
      views.musicCard.onClick = function()
        local position = holder.getAdapterPosition()
        local index = position + 1
        --更新音乐数据
        isLocalMusic = false
        isPMusic = false
        isUserAdd = true
        musicList = MusicData.getMusicList()
        --MusicSlider.setValue(0)
        name, artist, id, sequence = musicList[index].name, musicList[index].artist, musicList[index].id, index
        MusicData.saveHistory(index)
        Music.loadCover(id, img3)
        Music.MusicPlay(MusicData.getMusicRes(id))
        Music.loadLyric(id)
        NotificationUtil.updateNotification()
        NotificationUtil.updatePlaybackState()
      end
      views.musicCard.onLongClick = function()
        local position = holder.getAdapterPosition()
        local index = position + 1
        dialog=MaterialAlertDialogBuilder(this)
        .setTitle("删除音乐")
        .setMessage("要删除这首音乐吗？")
        .setPositiveButton("删除",{onClick=function(v) MusicData.deleteMusic(index)
            MusicData.deleteMusic(index)
            musicList = MusicData.getMusicList()
            updataAdp()
          end})
        .setNegativeButton("取消",nil)
        .show()
        dialog.create()
      end
      return holder
    end,

    onBindViewHolder = function(holder, position)
      local view = holder.view.getTag()
      local index = position + 1
      view.music2.setText(musicList[index].name)
      view.artist2.setText(musicList[index].artist)
      Http.get("https://y.music.163.com/m/song?id=" .. musicList[index].id, function(code, content)
        if code == 200 then
          local pic = string.match(content, '<meta property="og:image" content="(.-)" />')
          Glide.with(activity.getApplicationContext())
          .load(pic)
          .into(view.cover)
         else
          view.cover.setVisibility(View.GONE)
        end
      end)
    end,
  }))

  musicListRecyclerView.setAdapter(adp).setLayoutManager(LinearLayoutManager(activity))
end
updataAdp()
local Recadapter = SettingLayUtil.newAdapter(settingData)
settingRecyclerView
.setAdapter(Recadapter)
.setLayoutManager(LinearLayoutManager(this))
.setHasFixedSize(true)
nowIndex = 1
fab.onClick = function ()
  local transition = AutoTransition()
  transition.setDuration(300)
  TransitionManager.beginDelayedTransition(background, transition)
  collapsingtoolbarlayout.setVisibility(View.GONE)
  bottombar.setVisibility(View.GONE)
  transition.addListener({
    onTransitionEnd = function()
      fragmentManager.beginTransaction().setCustomAnimations(MDC_R.anim.mtrl_bottom_sheet_slide_in, MDC_R.anim.mtrl_bottom_sheet_slide_out).replace(FragmentContainers.getId(), Fragments[4]).commit()
      fab.hide()
      task(100,function()--1000毫秒=1秒
        if duration
          MusicSlider.setValueTo(duration)
          MusicSlider.setValueFrom(0)
        end
      end)
    end
  })
  isMusicPage = true
end

musiclistButton.onClick = function ()
  local transition = AutoTransition()
  transition.setDuration(300)
  TransitionManager.beginDelayedTransition(background, transition)
  collapsingtoolbarlayout.setVisibility(View.VISIBLE)
  bottombar.setVisibility(View.VISIBLE)
  transition.addListener({
    onTransitionEnd = function()
      fragmentManager.beginTransaction().setCustomAnimations(MDC_R.anim.mtrl_bottom_sheet_slide_in, MDC_R.anim.mtrl_bottom_sheet_slide_out).replace(FragmentContainers.getId(), Fragments[nowIndex]).commit()
      fab.show()
    end
  })
  isMusicPage = false
end

function onDestroy()
  if ti2 then
    ti2.stop()
    ti2 = nil
  end
  if mediaPlayer then
    mediaPlayer.stop()
    mediaPlayer.release()
    mediaPlayer = nil
  end
  local notificationManager = activity.getSystemService(Context.NOTIFICATION_SERVICE)
  notificationManager.cancel(NOTIFICATION_ID)
  if mediaSession ~= nil then
    mediaSession.release()
    mediaSession = nil
  end
  if receiver ~= nil then
    activity.unregisterReceiver(receiver)
    receiver = nil
  end
end

--MusicData.deleteMusic(2)
MusicSlider.addOnChangeListener{
  onValueChange = function(view, value, bool)
    currenttime.setText(Music.msTotime(value))
    NotificationUtil.updatePlaybackState()
  end,
}
MusicSlider.setLabelFormatter {
  getFormattedValue = function(value)
    return Music.msTotime(MusicSlider.getValue())
  end
}
MusicSlider.addOnSliderTouchListener({
  onStartTrackingTouch = function(view)
    isSeekbarTracking = true
  end,
  onStopTrackingTouch = function(view)
    if mediaPlayer and isPrepared then
      mediaPlayer.seekTo(MusicSlider.getValue())
      NotificationUtil.updatePlaybackState()
    end
    currenttime.setText(Music.msTotime(MusicSlider.getValue()))
    isSeekbarTracking = false
  end
})
lrcview.setDraggable(true, function(_, time)
  mediaPlayer.seekTo(math.floor(time))
  lrcview.updateTime(time)
  mediaPlayer.start()
  return true
end)

playbtn.onClick = function()
  if mediaPlayer then
    Music.autoPausePlay()
   else
    Music.loadCover(id)
    Music.MusicPlay(MusicData.getMusicRes(id))
  end
  NotificationUtil.updatePlaybackState()
  NotificationUtil.updateNotification()
end
lastButton.onClick = function()
  if isUserAdd then
    Music.MusicPlay(MusicData.lastMusic())
    NotificationUtil.updateNotification()
    NotificationUtil.updatePlaybackState()
   elseif isLocalMusic then
    LocalMusic.LocalMusicPlay(MusicData.lastMusic())
    NotificationUtil.updateNotification()
    NotificationUtil.updatePlaybackState()
   else
    pMusic.lastMusic()
    NotificationUtil.updateNotification()
    NotificationUtil.updatePlaybackState()
  end
end
nextButton.onClick = function()
  if isUserAdd then
    Music.MusicPlay(MusicData.nextMusic())
    NotificationUtil.updateNotification()
    NotificationUtil.updatePlaybackState()
   elseif isLocalMusic then
    LocalMusic.LocalMusicPlay(MusicData.nextMusic())
    NotificationUtil.updateNotification()
    NotificationUtil.updatePlaybackState()
   else
    pMusic.nextMusic()
    NotificationUtil.updateNotification()
    NotificationUtil.updatePlaybackState()
  end
end
downloadButton.onClick=function()
  if isUserAdd then
    Http.get("https://music.163.com/song/media/outer/url?id=" .. id .. ".mp3", function(code, content, _, header)
      local h = tostring(header)
      local url = string.match(h, "Location=%[(.-)%],")
      Http.download(url, "/storage/emulated/0/Download/" .. name .. ".mp3", function(code)
        if code == 200 then MaterialToast("开始下载，下载后的音乐将保存至Download目录内") else MaterialToast("音乐下载失败") end end)end)
   elseif isLocalMusic then
    MaterialToast("当前模式无法保存音乐")
   else
    Http.get("https://music.163.com/song/media/outer/url?id=" .. id .. ".mp3", function(code, content, _, header)
      local h = tostring(header)
      local url = string.match(h, "Location=%[(.-)%],")
      Http.download(url, "/storage/emulated/0/Download/" .. name .. ".mp3", function(code)
        if code == 200 then MaterialToast("开始下载，下载后的音乐将保存至Download目录内") else MaterialToast("音乐下载失败") end end)end)
  end
end

fold.onClick=function(v)
  local dialog = MaterialAlertDialogBuilder(this)
  dialog.setTitle("播放模式")
  dialog.setView(loadlayout("res.layout.dialog_playmode"))
  local dialog2 = dialog.create()
  dialog2.show()
  cycle.onClick=function()
    activity.setSharedData("setting_cycle",true)
    dialog2.dismiss()
    MaterialToast("循环播放")
  end
  cycle2.onClick=function()
    activity.setSharedData("setting_cycle",false)
    dialog2.dismiss()
    MaterialToast("轮播")
  end
end

more.onClick=function()
  MaterialAlertDialogBuilder(this)
  .setTitle("音乐信息")
  .setMessage("音乐 "..name.. "\n\n艺术家 " ..artist.. "\n\n路径 " ..tostring(path))
  .show()
end
shareButton.onClick=function()
  text="分享".. artist .."的《" .. name .."》"
  intent=Intent(Intent.ACTION_SEND);
  intent.setType("text/plain");
  intent.putExtra(Intent.EXTRA_SUBJECT, "分享");
  intent.putExtra(Intent.EXTRA_TEXT, text);
  intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
  activity.startActivity(Intent.createChooser(intent,"分享到:"));
end
Http.get("https://y.music.163.com/m/song?id=" .. id, function(code, content)
  if code == 200 then
    local pic = string.match(content, '<meta property="og:image" content="(.-)" />')
    Glide.with(activity.getApplicationContext())
    .load(pic)
    .into(img3)
  end
end)
Http.get("http://lingrain.online/announcement.json", function(code, content)
  if code == 200 then
    local table = json.decode(content)
    title.setText(table.title)
    content2.setText(table.content)
  end
end)
lrcview.setPicture(activity.getLuaDir() .. "/res/drawable/play.png")
Music.loadLyric(id)
Music.setButtonBounce(playbtn, 0.93, 70)
Music.setButtonBounce(lastButton, 0.93, 70)
Music.setButtonBounce(nextButton, 0.93, 70)


tab.setupWithViewPager(pagev)

local tableTitle = {
  "收藏";
  "本地";
  "p主";
}

for index = 0, tab.getTabCount() - 1 do
  tab.getTabAt(index).setText(tableTitle[index + 1])
end

function AutoNext()
  mediaPlayer.setOnCompletionListener(MediaPlayer.OnCompletionListener{
    onCompletion = function(mp)
      if not activity.getSharedData("setting_cycle") then
        MusicSlider.setValue(0)
        if isUserAdd then
          Music.MusicPlay(MusicData.nextMusic())
          NotificationUtil.updateNotification()
         elseif isLocalMusic then
          LocalMusic.LocalMusicPlay(MusicData.nextMusic())
          NotificationUtil.updateNotification()
         else
          pMusic.nextMusic()
          NotificationUtil.updateNotification()
          NotificationUtil.updatePlaybackState()
        end
       else
        mp.seekTo(0)
        mp.start()
      end
    end
  })
end

import "android.media.AudioManager"

local audioManager = activity.getSystemService(Context.AUDIO_SERVICE)

-- 音频焦点变化监听器
local focusListener = {
  onAudioFocusChange = function(focusChange)
    if focusChange == AudioManager.AUDIOFOCUS_LOSS or
      focusChange == AudioManager.AUDIOFOCUS_LOSS_TRANSIENT then
      if mediaPlayer

        Music.autoPausePlay()
        NotificationUtil.updateNotification()
        NotificationUtil.updatePlaybackState()

      end
     elseif focusChange == AudioManager.AUDIOFOCUS_GAIN then
      if mediaPlayer

        Music.autoPausePlay()
        NotificationUtil.updateNotification()
        NotificationUtil.updatePlaybackState()

      end
    end
  end
}

-- 请求音频焦点
result = audioManager.requestAudioFocus(
focusListener,
AudioManager.STREAM_MUSIC,
AudioManager.AUDIOFOCUS_GAIN
)
function onKeyDown(code,event)
  if string.find(tostring(event),"KEYCODE_BACK") ~= nil then
    if isMusicPage then
      local transition = AutoTransition()
      transition.setDuration(300)
      TransitionManager.beginDelayedTransition(background, transition)
      collapsingtoolbarlayout.setVisibility(View.VISIBLE)
      bottombar.setVisibility(View.VISIBLE)
      transition.addListener({
        onTransitionEnd = function()
          fragmentManager.beginTransaction().setCustomAnimations(MDC_R.anim.mtrl_bottom_sheet_slide_in, MDC_R.anim.mtrl_bottom_sheet_slide_out).replace(FragmentContainers.getId(), Fragments[nowIndex]).commit()
          fab.show()
        end
      })
      isMusicPage = false
      return true
     else
      activity.finish()
      return true
    end
    return true
  end
end

if activity.getSharedData("AutoPlay") then
  Music.MusicPlay(MusicData.getMusicRes(id))
  Music.loadLyric(id)
  NotificationUtil.updateNotification()
  NotificationUtil.updatePlaybackState()
end