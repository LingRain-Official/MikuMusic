local MaterialAlertDialogBuilder = luajava.bindClass "com.google.android.material.dialog.MaterialAlertDialogBuilder"
local SettingLayUtil = require "mods.utils.SettingLayUtil"
local MyPopupMenu = require "mods.utils.MyPopupMenu"
local function recreate()
  task(300, function()
    this.recreate()
  end)
end
local MaterialAlertDialogBuilder = luajava.bindClass "com.google.android.material.dialog.MaterialAlertDialogBuilder"
local SettingLayUtil = require "mods.utils.SettingLayUtil"
local MyPopupMenu = require "mods.utils.MyPopupMenu"
return{
  {
    SettingLayUtil.TITLE,
    title="播放",
  },
  {
    SettingLayUtil.ITEM_SWITCH,
    title="自动播放",
    message="进入应用后自动播放",
    icon=activity.getLuaDir().."/res/drawable/play.png",
    checked = this.getSharedData("AutoPlay"),
    event = function(_, checked)
      this.setSharedData("AutoPlay", checked)
      recreate()
    end
  },
  {
    SettingLayUtil.ITEM_SWITCH,
    title="音乐缓存",
    message="在播放未缓存音乐的同时下载音乐至应用私有目录内，下次播放无需下载与消耗流量，可离线播放音乐(会导致应用体积变大)",
    icon=activity.getLuaDir().."/res/drawable/music.png",
    checked = this.getSharedData("setting_MusicCache"),
    event = function(_, checked)
      this.setSharedData("setting_MusicCache", checked)
      recreate()
    end
  },
}