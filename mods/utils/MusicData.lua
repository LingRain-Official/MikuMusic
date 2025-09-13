local _M = {}
local MusicModule = require "mods.utils.MusicModule"
local json = require "json"
local hisPath = activity.getLuaDir() .. "/res/data/history.json"
local musicListPath = activity.getLuaDir() .. "/res/data/data.json"
local MaterialToast = require "mods.views.Toast"
local File = luajava.bindClass "java.io.File"
function _M.getHistoryMusic()
  local open = io.open(hisPath, "r")
  local hisContent = open:read("*a")
  io.close()
  local his = json.decode(hisContent)
  return his
end

function _M.getMusicList()
  local open = io.open(musicListPath, "r")
  local musicListContent = open:read("*a")
  io.close()
  local musicList = json.decode(musicListContent)
  return musicList
end

function _M.getMusicRes(id)
  if activity.getSharedData("setting_MusicCache") then
    if File(activity.getLuaDir() .. "/local/" .. id .. ".mp3").isFile() then
      return activity.getLuaDir() .. "/local/" .. id .. ".mp3"
     else
      _M.DownloadRes("https://music.163.com/song/media/outer/url?id=" .. id .. ".mp3", id .. ".mp3")
      return "https://music.163.com/song/media/outer/url?id=" .. id .. ".mp3"
    end
   else
    return "https://music.163.com/song/media/outer/url?id=" .. id .. ".mp3"
  end
end

function _M.DownloadRes(MusicUrl, FileName)
  Http.get(MusicUrl, function(code, content, _, header)
    local h = tostring(header)
    local url = string.match(h, "Location=%[(.-)%],")
    Http.download(url, activity.getLuaDir() .. "/local/" .. FileName, function(code)
      if code == 200 then
       else
        MaterialToast("音乐下载失败")
      end
    end)
  end)
end

function _M.addMusic(id)
  local musicList = _M.getMusicList()
  local isDuplicate = false
  for _, value in pairs(musicList) do
    if id == value.id then
      isDuplicate = true
      break
    end
  end
  if isDuplicate then
    MaterialToast("你已经添加过这首歌了")
    return false
   else
    Http.get("https://y.music.163.com/m/song?id=" .. id, function(code, content)
      if code == 200 then
        local name, artist = string.match(content, '<meta property="og:title" content="(.-) %- (.-) %- .- %- 网易云音乐" />')
        table.insert(musicList, {["name"] = name, ["artist"] = artist, ["id"] = id})
        local tojsonTable = json.encode(musicList)
        io.open(musicListPath, "w"):write(tojsonTable):close()
      end
    end)
    MaterialToast("添加成功")
    musicList = _M.getMusicList()
    return true
  end
end

function _M.deleteMusic(sequence)
  local musicList = _M.getMusicList()
  if not #musicList == 1 then
    if sequence > #musicList or sequence <= 0 then
      --print("错误，当前函数为: " .. debug.getinfo(1, "n").name)
      return false
    end
    table.remove(musicList, sequence)
    local tojsonTable = json.encode(musicList)
    io.open(musicListPath, "w"):write(tojsonTable):close()
  end
end

function _M.saveHistory(sequence)
  local musicList = _M.getMusicList()
  io.open(hisPath, "w"):write(json.encode({["name"] = musicList[sequence].name, ["artist"] = musicList[sequence].artist, ["id"] = musicList[sequence].id, ["sequence"] = sequence})):close()
end

function _M.nextMusic()

  local musicList = _M.getMusicList()

  if not isLocalMusic then
    max = #musicList
   else
    max = #localMusicList
  end
  sequence = sequence + 1
  if sequence > max then
    --越出索引范围，返回歌单VOCALOID第一首
    sequence = 1
    --直接快捷更新所有需要更新的内容

    if not isLocalMusic then
      name, artist, id = musicList[sequence].name, musicList[sequence].artist, musicList[1].id
      _M.saveHistory(sequence)
      MusicModule.loadLyric(id)
      MusicModule.loadCover(id, img3)
      return _M.getMusicRes(musicList[1].id)
     else
      name, artist, path, duration, album, id = localMusicList[sequence].name, localMusicList[sequence].artist, localMusicList[sequence].path, localMusicList[sequence].duration, localMusicList[sequence].album, localMusicList[sequence].id
      return localMusicList[1].path
    end

   else

    if not isLocalMusic then
      name, artist, id = musicList[sequence].name, musicList[sequence].artist, musicList[sequence].id
      _M.saveHistory(sequence)
      MusicModule.loadLyric(id)
      MusicModule.loadCover(id, img3)
      return _M.getMusicRes(musicList[sequence].id)
     else
      name, artist, path, duration, album, id = localMusicList[sequence].name, localMusicList[sequence].artist, localMusicList[sequence].path, localMusicList[sequence].duration, localMusicList[sequence].album, localMusicList[sequence].id
      print(name)
      return localMusicList[sequence].path
    end

  end
end

function _M.lastMusic()

  local musicList = _M.getMusicList()

  sequence = sequence - 1
  if sequence == 0 then
    --越出索引范围，返回最后一首
    --如果是本地音乐，将musicList[#musicList].id替换为路径
    if not isLocalMusic then
      sequence = #musicList
     else
      sequence = #localMusicList
    end

    if not isLocalMusic then
      name, artist, id = musicList[sequence].name, musicList[sequence].artist, musicList[sequence].id
      _M.saveHistory(sequence)
      MusicModule.loadLyric(id)
      MusicModule.loadCover(id, img3)
      return _M.getMusicRes(musicList[#musicList].id)
     else
      name, artist, path, duration, album, id = localMusicList[sequence].name, localMusicList[sequence].artist, localMusicList[sequence].path, localMusicList[sequence].duration, localMusicList[sequence].album, localMusicList[sequence].id
      return localMusicList[sequence].path
    end

   else

    if not isLocalMusic then
      name, artist, id = musicList[sequence].name, musicList[sequence].artist, musicList[sequence].id
      _M.saveHistory(sequence)
      MusicModule.loadLyric(id)
      MusicModule.loadCover(id, img3)
      return _M.getMusicRes(musicList[sequence].id)
     else
      name, artist, path, duration, album, id = localMusicList[sequence].name, localMusicList[sequence].artist, localMusicList[sequence].path, localMusicList[sequence].duration, localMusicList[sequence].album, localMusicList[sequence].id
      return localMusicList[sequence].path
    end

  end
end

function _M.sltoid(sl)
  local id = string.match(tostring(sl), "id=([0-9]-)&")
  if not id then
    local http = require "http"
    pcall(function()
      local _, _, _, h = http.get(sl)
      id = string.match(h.location, "id=([0-9]-)&")
    end)
  end
  return id
end

function _M.sltoid2(sl, func)
  Http.get(sl, function(code, content, _, header)
    print(header.location)
    local id = string.match(tostring(header), "Location=%[.-id=([0-9]-)&.-%],")

    func(id)
  end)
end

function _M.sltoid3(sl)
  local id = string.match(tostring(sl), "id=(%d+)")
  if not id then
    local http = require "http"
    pcall(function()
      local _, _, _, h = http.get(sl)
      id = string.match(h.location, "id=(%d+)")

    end)
  end
  return id
end


return _M