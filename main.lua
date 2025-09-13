require "activity.MainActivity.MainActivity"
if not activity.getSharedData("welcome") then
  print("开始初始化配置")
  activity.setSharedData("setting_MusicCache", true)
  activity.setSharedData("AutoPlay", false)
  activity.setSharedData("setting_DynamicColors", true)
  activity.setSharedData("setting_theme", "my")
  activity.setSharedData("welcome",true)
end