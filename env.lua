require "import"

import "mods.utils.m3-import"

import "android.view.*"
import "android.view.View"
--loadlayout = require "mods.utils.loadlayout"
bindClass = luajava.bindClass

local UiUtil = require "mods.utils.UiUtil"
MaterialToast = require "mods.views.Toast"
Colors = require "qr.material.Colors"
Layout = require "mods.utils.LayoutUtil"

local WindowManager = luajava.bindClass "android.view.WindowManager"
local View = luajava.bindClass "android.view.View"
local Build = luajava.bindClass "android.os.Build"
local ColorDrawable = luajava.bindClass "android.graphics.drawable.ColorDrawable"
local MaterialAlertDialogBuilder = luajava.bindClass"com.google.android.material.dialog.MaterialAlertDialogBuilder"
local Build = luajava.bindClass "android.os.Build"
local EdgeToEdge = luajava.bindClass "androidx.activity.EdgeToEdge"
local window = activity.getWindow()

if activity.getSharedData("setting_theme") == "my" then
  CollapsingToolbarLayoutColor = 0
  if activity.getSharedData("setting_DynamicColors") == true
    activity.setTheme(MDC_R.style.Theme_Material3_DynamicColors_DayNight_NoActionBar)
   else
    activity.setTheme(MDC_R.style.Theme_Material3_DayNight_NoActionBar)
  end
 elseif activity.getSharedData("setting_theme") == "mc" then
  CollapsingToolbarLayoutColor = Colors.colorBackground
  activity.setTheme(MDC_R.style.Theme_MaterialComponents_DayNight_NoActionBar)
 else
  CollapsingToolbarLayoutColor = 0
  activity.setTheme(MDC_R.style.Theme_Material3_DynamicColors_DayNight_NoActionBar)
end

window.setSoftInputMode(0x10)
.setStatusBarColor(Colors.colorBackground)
.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)

if UiUtil.isNightMode() then
  window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_VISIBLE)
  RippleColor = 0x31FFFFFF
 else
  window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR)
  RippleColor = 0x31000000
end

--一些重要的用于调试的函数
function traceback(err)
  local level = 2
  local info = debug.getinfo(level, "n")
  local funcName = info.name or "<anonymous>"
  MaterialAlertDialogBuilder(this)
  .setTitle("[Error]")
  .setMessage(string.format("Error in function '%s': %s", funcName, err))
  .show()
end
function dump(value, indent, visited)
  indent = indent or ""
  visited = visited or {}
  local ty = type(value)
  if ty == "nil" then
    return "nil"
   elseif ty == "boolean" then
    return value and "true" or "false"
   elseif ty == "number" then
    return tostring(value)
   elseif ty == "string" then
    return string.format("%q", value)
   elseif ty == "function" then
    return "<function>"
   elseif ty == "thread" then
    return "<thread>"
   elseif ty == "userdata" then
    return "<userdata>"
   elseif ty == "table" then
    if visited[value] then
      return "<cycle>"
    end
    visited[value] = true
    local result = "{\n"
    local new_indent = indent .. "  "
    for k, v in pairs(value) do
      result = result .. new_indent .. "[" .. dump(k, new_indent, visited) .. "] = " .. dump(v, new_indent, visited) .. ",\n"
    end
    return result .. indent .. "}"
   else
    return "<unknown>"
  end
end
build = {

}
function dp2px(dpValue)
  local scale = activity.getResources().getDisplayMetrics().density
  return Math.round(dpValue * scale)
end

--[==[
 ___       ___  ________   ________  ________  ________  ___  ________      
|\  \     |\  \|\   ___  \|\   ____\|\   __  \|\   __  \|\  \|\   ___  \    
\ \  \    \ \  \ \  \\ \  \ \  \___|\ \  \|\  \ \  \|\  \ \  \ \  \\ \  \   
 \ \  \    \ \  \ \  \\ \  \ \  \  __\ \   _  _\ \   __  \ \  \ \  \\ \  \  
  \ \  \____\ \  \ \  \\ \  \ \  \|\  \ \  \\  \\ \  \ \  \ \  \ \  \\ \  \ 
   \ \_______\ \__\ \__\\ \__\ \_______\ \__\\ _\\ \__\ \__\ \__\ \__\\ \__\
    \|_______|\|__|\|__| \|__|\|_______|\|__|\|__|\|__|\|__|\|__|\|__| \|__|
]==]