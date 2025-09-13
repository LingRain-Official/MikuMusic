require "env"
local json = require "json"
local MediaStore = luajava.bindClass "android.provider.MediaStore"
local resolver = activity.getContentResolver()
local LinearLayoutManager = luajava.bindClass "androidx.recyclerview.widget.LinearLayoutManager"
local Glide = luajava.bindClass "com.bumptech.glide.Glide"
local LuaCustRecyclerAdapter = luajava.bindClass "com.lua.custrecycleradapter.LuaCustRecyclerAdapter"
local AdapterCreator = luajava.bindClass "com.lua.custrecycleradapter.AdapterCreator"
local LuaCustRecyclerHolder = luajava.bindClass "com.lua.custrecycleradapter.LuaCustRecyclerHolder"
local DiskCacheStrategy = luajava.bindClass "com.bumptech.glide.load.engine.DiskCacheStrategy"
local MusicData = require "mods.utils.MusicData"
local NotificationUtil = require "mods.utils.NotificationUtil"
local LocalMusic = require "mods.utils.LocalMusicModule"

-- 查询外部存储中的音频文件
local cursor = resolver.query(
MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
nil,
MediaStore.Audio.Media.IS_MUSIC .. " != 0 AND " ..
MediaStore.Audio.Media.DURATION .. " >= 30000",
nil,
MediaStore.Audio.Media.TITLE .. " ASC"
)

localMusicList = {} -- 初始化空表

if cursor then
  while cursor.moveToNext() do
    -- 获取音乐信息
    local id = cursor.getString(cursor.getColumnIndex(MediaStore.Audio.Media._ID))
    local title = cursor.getString(cursor.getColumnIndex(MediaStore.Audio.Media.TITLE))
    local artist = cursor.getString(cursor.getColumnIndex(MediaStore.Audio.Media.ARTIST))
    local album = cursor.getString(cursor.getColumnIndex(MediaStore.Audio.Media.ALBUM))
    local duration = cursor.getString(cursor.getColumnIndex(MediaStore.Audio.Media.DURATION))
    local path = cursor.getString(cursor.getColumnIndex(MediaStore.Audio.Media.DATA))

    -- 正确的方式：将新项添加到表中
    table.insert(localMusicList, {
      ["name"] = title,
      ["artist"] = artist,
      ["path"] = path,
      ["duration"] = duration,
      ["album"] = album,
      ["id"] = id,
    })
  end
  cursor.close()
  local adp = {
    getItemCount = function()
      return #localMusicList
    end,
    onCreateViewHolder = function(parent, viewType) local views = {} --控件存在这里面
      local holder = LuaCustRecyclerHolder(loadlayout("res.layout.item_localmusic", views))
      holder.view.setTag(views)
      views.musicCard.onClick = function()
        local position = holder.getAdapterPosition()
        local index = position + 1
        isLocalMusic = true
        isPMusic = false
        isUserAdd = false
        sequence = index
        name, artist, path, duration, album, id = localMusicList[sequence].name, localMusicList[sequence].artist, localMusicList[sequence].path, localMusicList[sequence].duration, localMusicList[sequence].album, localMusicList[sequence].id
        LocalMusic.LocalMusicPlay(path)
        lrcview.loadLrc(nil)
      end
      return holder
    end,
    onBindViewHolder = function(holder, position) --position:item的位置
      local view = holder.view.getTag() --控件存在这里面
      local index = position + 1
      view.artist.setText(localMusicList[index].artist)
      view.music.setText(localMusicList[index].name)
    end,
  }
  local adp2 = LuaCustRecyclerAdapter(AdapterCreator(adp))
  localMusicRecyclerView
  .setAdapter(adp2)
  .setLayoutManager(LinearLayoutManager(activity))
end

