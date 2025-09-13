local _M = {}
local bindClass = luajava.bindClass

_M.isNightMode=function()
  local Configuration= bindClass"android.content.res.Configuration"
  local currentNightMode = activity.getResources().getConfiguration().uiMode & Configuration.UI_MODE_NIGHT_MASK
  return currentNightMode == Configuration.UI_MODE_NIGHT_YES
end

_M.getStatusBarHeight=function()
  local resourceId = activity.getResources().getIdentifier("status_bar_height", "dimen", "android")
  return activity.getResources().getDimensionPixelSize(resourceId)
end

local function isEdgeToEdgeEnabled()
  local Build = bindClass "android.os.Build"
  return (Build.VERSION.SDK_INT >= 29)
end

_M.applyEdgeToEdgePreference=function(window)
  pcall(function()
    local EdgeToEdgeUtils = bindClass "com.google.android.material.internal.EdgeToEdgeUtils"
    EdgeToEdgeUtils.applyEdgeToEdge(window, isEdgeToEdgeEnabled())
    EdgeToEdgeUtils = nil
  end)
end

local function isColorLight(i, z)
  local MaterialColors = bindClass "com.google.android.material.color.MaterialColors"
  return MaterialColors.isColorLight(i) or (i == 0 and z)
end

_M.statusBarAndNavigationBarColor=function(window,color,z)
  pcall(function()
    local WindowCompat = bindClass "androidx.core.view.WindowCompat"
    local insetsController = WindowCompat.getInsetsController(window, window.getDecorView())
    local myIsColorLight = isColorLight(color,z)

    insetsController.setAppearanceLightStatusBars(myIsColorLight)
    insetsController.setAppearanceLightNavigationBars(myIsColorLight)

    window.setStatusBarColor(color)
    window.setNavigationBarColor(color)

    WindowCompat,insetsController,myIsColorLight = nil,nil,nil
  end)
end

function _M.applyRippleEffect(color,color2,topLeft,topRight,bottomLeft,bottomRight)
  local GradientDrawable = bindClass "android.graphics.drawable.GradientDrawable"
  local gradientDrawable = GradientDrawable()
  .setShape(0)
  .setColor(color)
  .setCornerRadii{dp2px(topLeft),dp2px(topLeft),dp2px(topRight),dp2px(topRight),
    dp2px(bottomRight),dp2px(bottomRight),dp2px(bottomLeft),dp2px(bottomLeft)}

  local RippleDrawable = bindClass "android.graphics.drawable.RippleDrawable"
  local ColorStateList = bindClass "android.content.res.ColorStateList"
  local rippleDrawable = RippleDrawable(ColorStateList.valueOf(color2), gradientDrawable, nil)

  GradientDrawable = nil
  gradientDrawable = nil
  ColorStateList,RippleDrawable = nil
  return rippleDrawable
end

return _M