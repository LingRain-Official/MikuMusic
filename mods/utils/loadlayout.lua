--- 布局加载模块
---@author Xiayu372
---@version 1.5

-- global to local
local require = require
local _G = _G
local pairs = pairs
local ipairs = ipairs
local tonumber = tonumber
local tostring = tostring
local error = error
local assert = assert
local pcall = pcall
local type = type
local rawset = rawset
local rawget = rawget
local activity = activity
local string = string
local table = table
local luajava = luajava
local stringMatch = string.match
local stringGsub = string.gsub
local stringFind = string.find
local stringUpper = string.upper
local stringLower = string.lower
local stringSub = string.sub
local stringFormat = string.format
local tableUnpack = table.unpack
local tableInsert = table.insert
local tableConcat = table.concat
local bindClass = luajava.bindClass
local newInstance = luajava.newInstance
local override = luajava.override
local instanceof = luajava.instanceof

local String = bindClass "java.lang.String"
local AndroidR = bindClass "android.R"
local View = bindClass "android.view.View"
local ViewGroup = bindClass "android.view.ViewGroup"
local Color = bindClass "android.graphics.Color"
local Typeface = bindClass "android.graphics.Typeface"
local ScaleType = bindClass "android.widget.ImageView$ScaleType"
local ArrayListAdapter = bindClass "android.widget.ArrayListAdapter"
local TruncateAt = bindClass "android.text.TextUtils$TruncateAt"
local ContextThemeWrapper = bindClass "androidx.appcompat.view.ContextThemeWrapper"
local TooltipCompat = bindClass "androidx.appcompat.widget.TooltipCompat"
local PagerAdapter = bindClass "androidx.viewpager.widget.PagerAdapter"
local MaterialColors = bindClass "com.google.android.material.color.MaterialColors"
local MaterialR = bindClass "com.google.android.material.R"
local NineBitmapDrawable = bindClass "com.androlua.NineBitmapDrawable"
local LuaBitmapDrawable = bindClass "com.androlua.LuaBitmapDrawable"
local LuaBitmap = bindClass "com.androlua.LuaBitmap"
local Glide = bindClass "com.bumptech.glide.Glide"
local DiskCacheStrategy = bindClass "com.bumptech.glide.load.engine.DiskCacheStrategy"
local RequestOptions = bindClass "com.bumptech.glide.request.RequestOptions"

local loadlayout
local scaleTypeEnum = ScaleType.values()
local metrics = activity.getResources().getDisplayMetrics()
local widthPixels = metrics.widthPixels
local heightPixels = metrics.heightPixels
local density = metrics.density
local scaledDensity = metrics.scaledDensity
local xdpi = metrics.xdpi

local excludeAttributes = {
  [1] = true,
  layout_width = true,
  layout_height = true,
  layout_margin = true,
  layout_marginHorizontal = true,
  layout_marginVertical = true,
  layout_marginLeft = true,
  layout_marginTop = true,
  layout_marginRight = true,
  layout_marginBottom = true,
  padding = true,
  paddingHorizontal = true,
  paddingVertical = true,
  paddingLeft = true,
  paddingTop = true,
  paddingRight = true,
  paddingBottom = true,
  paddingStart = true,
  paddingEnd = true,
  theme = true,
  style = true,
  id = true,
  viewId = true
}

local ruleConstants = {
  layout_above = 2,
  layout_alignBaseline = 4,
  layout_alignBottom = 8,
  layout_alignEnd = 19,
  layout_alignLeft = 5,
  layout_alignParentBottom = 12,
  layout_alignParentEnd = 21,
  layout_alignParentLeft = 9,
  layout_alignParentRight = 11,
  layout_alignParentStart = 20,
  layout_alignParentTop = 10,
  layout_alignRight = 7,
  layout_alignStart = 18,
  layout_alignTop = 6,
  layout_alignWithParentIfMissing = 0,
  layout_below = 3,
  layout_centerHorizontal = 14,
  layout_centerInParent = 13,
  layout_centerVertical = 15,
  layout_toEndOf = 17,
  layout_toLeftOf = 0,
  layout_toRightOf = 1,
  layout_toStartOf = 16
}

local sizeConstants = {
  match = -1,
  wrap = -2,
  match_parent = -1,
  fill_parent = -1,
  wrap_content = -2,
  fill = -1
}

local scaleTypeConstants = {
  matrix = 0,
  fitXY = 1,
  fitStart = 2,
  fitCenter = 3,
  fitEnd = 4,
  center = 5,
  centerCrop = 6,
  centerInside = 7
}

local gravityConstants = {
  axis_clip = 8,
  axis_pull_after = 4,
  axis_pull_before = 2,
  axis_specified = 1,
  axis_x_shift = 0,
  axis_y_shift = 4,
  bottom = 80,
  center = 17,
  center_horizontal = 1,
  center_vertical = 16,
  clip_horizontal = 8,
  clip_vertical = 128,
  display_clip_horizontal = 16777216,
  display_clip_vertical = 268435456,
  fill = 119,
  fill_horizontal = 7,
  fill_vertical = 112,
  horizontal_gravity_mask = 7,
  left = 3,
  no_gravity = 0,
  relative_horizontal_gravity_mask = 8388615,
  relative_layout_direction = 8388608,
  right = 5,
  start = 8388611,
  top = 48,
  vertical_gravity_mask = 112,
  ["end"] = 8388613
}

local layoutBehaviorConstants = {
  appbar_scrolling_view_behavior = "com.google.android.material.appbar.AppBarLayout$ScrollingViewBehavior",
  bottom_sheet_behavior = "com.google.android.material.bottomsheet.BottomSheetBehavior",
  fab_transformation_scrim_behavior = "com.google.android.material.transformation.FabTransformationScrimBehavior",
  fab_transformation_sheet_behavior = "com.google.android.material.transformation.FabTransformationSheetBehavior",
  hide_bottom_view_on_scroll_behavior = "com.google.android.material.behavior.HideBottomViewOnScrollBehavior"
}

-- 定义过且一样的值或者改成if判断的值会注释掉
local viewConstants = {
  -- android:drawingCacheQuality
  -- auto = 0,
  -- low  = 1,
  -- high = 2,

  -- android:importantForAccessibility
  -- auto = 0,
  -- yes  = 1,
  -- no   = 2,

  -- android:layerType
  -- none     = 0,
  -- software = 1,
  -- hardware = 2,

  -- android:layoutDirection
  ltr = 0,
  rtl = 1,
  inherit = 2,
  locale = 3,

  -- android:scrollbarStyle
  insideOverlay = 0x0,
  insideInset = 0x01000000,
  outsideOverlay = 0x02000000,
  outsideInset = 0x03000000,

  -- android:visibility
  -- visible   = 0,
  -- invisible = 4,
  -- gone      = 8,

  -- android:autoLink
  none = 0x00,
  web = 0x01,
  email = 0x02,
  phon = 0x04,
  map = 0x08,
  all = 0x0f,

  -- android:orientation
  -- vertical   = 1,
  -- horizontal = 0,

  -- android:textAlignment
  inherit = 0,
  gravity = 1,
  textStart = 2,
  textEnd = 3,
  textCenter = 4,
  viewStart = 5,
  viewEnd = 6,

  -- android:inputType
  -- none             = 0x00000000,
  text = 0x00000001,
  textCapCharacters = 0x00001001,
  textCapWords = 0x00002001,
  textCapSentences = 0x00004001,
  textAutoCorrect = 0x00008001,
  textAutoComplete = 0x00010001,
  textMultiLine = 0x00020001,
  textImeMultiLine = 0x00040001,
  textNoSuggestions = 0x00080001,
  textUri = 0x00000011,
  textEmailAddress = 0x00000021,
  textEmailSubject = 0x00000031,
  textShortMessage = 0x00000041,
  textLongMessage = 0x00000051,
  textPersonName = 0x00000061,
  textPostalAddress = 0x00000071,
  textPassword = 0x00000081,
  textVisiblePassword = 0x00000091,
  textWebEditText = 0x000000a1,
  textFilter = 0x000000b1,
  textPhonetic = 0x000000c1,
  textWebEmailAddress = 0x000000d1,
  textWebPassword = 0x000000e1,
  number = 0x00000002,
  numberSigned = 0x00001002,
  numberDecimal = 0x00002002,
  numberPassword = 0x00000012,
  phone = 0x00000003,
  datetime = 0x00000004,
  date = 0x00000014,
  time = 0x00000024,

  -- android:imeOptions
  normal = 0x00000000,
  actionUnspecified = 0x00000000,
  actionNone = 0x00000001,
  actionGo = 0x00000002,
  actionSearch = 0x00000003,
  actionSend = 0x00000004,
  actionNext = 0x00000005,
  actionDone = 0x00000006,
  actionPrevious = 0x00000007,
  flagNoFullscreen = 0x2000000,
  flagNavigatePrevious = 0x4000000,
  flagNavigateNext = 0x8000000,
  flagNoExtractUi = 0x10000000,
  flagNoAccessoryAction = 0x20000000,
  flagNoEnterAction = 0x40000000,
  flagForceAscii = 0x80000000,

  -- layout_scrollFlags
  noScroll = 0,
  scroll = 1,
  exitUntilCollapsed = 2,
  enterAlways = 4,
  enterAlwaysCollapsed = 8,
  snap = 16,
  snapMargins = 32,

  -- layout_collapseMode
  -- pin      = 1,
  -- parallax = 2
}

local unitConstants = {
  px = 0, dp = 1,
  sp = 2, pt = 3,
  ["in"] = 4, mm = 5
}

local dimensionConverterMap = {
  px = function(v) return v end,
  dp = function(v) return density * v end,
  sp = function(v) return scaledDensity * v end,
  pt = function(v) return xdpi * v * 0.013888889 end,
  ["in"] = function(v) return xdpi * v end,
  mm = function(v) return xdpi * v * 0.03937008 end,
-- 修正后的百分比计算
["%w"] = function(v) return widthPixels * v * 0.01 end,
["%h"] = function(v) return heightPixels * v * 0.01 end
}

-- 让require可以导入aly后缀的文件
local function alyloader(path)
  local alypath = stringGsub(package.path, "%.lua;", ".aly;")
  local path, msg = package.searchpath(path, alypath)
  if msg then return msg end
  local f = io.open(path)
  local s = f:read("*a")
  f:close()
  if stringSub(s, 1, 4) == "\27Lua" then
    return assert(loadfile(path)), path
   else
    local f, st = load("return " .. s, stringMatch(path, "[^/]+/[^/]+$"), "bt")
    if st then
      error(stringGsub(st, "%b[]", path, 1), 0)
    end
    return f, st
  end
end
tableInsert(package.searchers, alyloader)

--- 把表转换为字符串
---@param t table
---@return string
local function dump(t)
  local _t = {
    tostring(t),
    "\t{"
  }
  for k, v in pairs(t) do
    if type(v) == "table" then
      tableInsert(_t, "\t\t" .. tostring(k) .. " = { " .. tostring(v[1]) .. " ... }")
     else
      tableInsert(_t, "\t\t" .. tostring(k) .. " = " .. tostring(v))
    end
  end
  tableInsert(_t, "\t}")
  return tableConcat(_t, "\n")
end

local dimensionCache = {} -- 缓存尺寸计算结果
--- 把尺寸转换为对应的px
---@param value string|number
---@return number
local function parseDimension(value)
  local result = tonumber(value) or dimensionCache[value]
  if result then return result end

  local num, unit = stringMatch(value, "([%+%-]?[%d%.]+)([%%%a]+)")
  num = assert(tonumber(num), "Unknown dimension " .. value)

  local converter = dimensionConverterMap[unit]
  if converter then
    result = converter(num)
   else
    error("Unknown dimension " .. value, 2)
  end

  dimensionCache[value] = result
  return result
end

--- 解析大小
---@param value string|number
---@return number
local function parseSize(value)
  return sizeConstants[value] or parseDimension(value)
end

--- 获取R类中代表颜色的attr
---@param color string 颜色名
---@return number
local function getColorAttr(color)
  local success, result = pcall(function() return MaterialR.attr[color] end)
  if success then return result end

  success, result = pcall(function() return AndroidR.attr[color] end)
  if success then return result end

  error("Unknown color " .. color, 2)
end

--- 把颜色值解析为十六进制数
---@param value string|number
---@return number
local function parseColor(value)
  local result = tonumber(value)
  if result then return result end

  if type(value) == "string" then
    if stringSub(value, 1, 1) == "?" then
      return MaterialColors.getColorOrNull(activity, getColorAttr(stringSub(value, 2)))
     else
      return Color.parseColor(value)
    end
  end

  error("Unknown color: " .. value, 2)
end

--- 解析常量文本
---@param value string|number 需要解析的常量值
---@param constants table 在此表中查询常量
---@return number
local function parseConstants(value, constants)
  local result = tonumber(value)
  if result then return result end

  result = 0
  for item in (value .. "|"):gmatch("(.-)|") do
    local newItem = constants[item] or tonumber(item)
    assert(newItem, "Unknown value " .. item)
    result = result | newItem
  end
  return result
end

--- 解析任意值
---@param value any
---@return any
local function parseValue(value)
  local valueType = type(value)
  if valueType == "string" then
    local result = tonumber(value)

    if result then
      return result
     elseif value == "true" then
      return true
     elseif value == "false" then
      return false
     elseif value == "nil" then
      return nil
     elseif stringFind(value, "^#[%da-fA-F]+$") then
      return Color.parseColor(value)
    end

    -- 解析尺寸
    local num, unit = stringMatch(value, "([%+%-]?[%d%.]+)([%%%a]+)")
    num = tonumber(num)
    if num and unit then
      result = dimensionCache[value]
      if result then return result end
      local converter = dimensionConverterMap[unit]
      if converter then result = converter(num) end
      if result then
        dimensionCache[value] = result
        return result
      end
    end

    -- 解析常量
    result = 0
    for item in (value.."|"):gmatch("(.-)|") do
      local newItem = viewConstants[item] or tonumber(item)
      if not newItem then
        result = nil
        break
      end
      result = result | newItem
    end
    if result then
      return result
    end
  end
  return value
end

--- 解析表中所有值
---@param value table
---@return any
local function parseValues(value)
  for k, v in ipairs(value) do
    value[k] = parseValue(v)
  end
  return tableUnpack(value)
end

--- 用于ViewPager
---@param pageViews table
---@param pageTitles table
---@return PagerAdapter
local function LuaPagerAdapter(pageViews, pageTitles)
  return override(PagerAdapter, {
    getCount = function(super)
      return int(#pageViews)
    end,
    instantiateItem = function(super, container, position)
      local pageView = pageViews[position + 1]
      container.addView(pageView)
      return pageView
    end,
    destroyItem = function(super, container, position, object)
      local pageView = pageViews[position + 1]
      container.removeView(pageView)
    end,
    isViewFromObject = function(super, view, object)
      return view == object
    end,
    getPageTitle = pageTitles and function(super, position)
      return pageTitles[position + 1]
    end or nil
  })
end

-- 存储设置属性方法的表
local attributeSetterMap = {
  items = function(view, value)
    local adapter = view.getAdapter()
    if adapter then
      adapter.addAll(value)
     else
      adapter = ArrayListAdapter(activity, AndroidR.layout.simple_list_item_1, String(value))
      view.setAdapter(adapter)
    end
  end,
  pages = function(view, value, valueType, layoutParams, views)
    local pages = {}
    for k, v in ipairs(value) do
      local vType = type(v)
      pages[k] = (vType == "string" or vType == "table") and
      loadlayout(v, views) or v
    end
    view.setAdapter(LuaPagerAdapter(pages))
  end,
  pagesWithTitle = function(view, value, valueType, layoutParams, views)
    --[[
        pagesWithTitle = {
          {
            pages...
          },
          {
            title...
          }
        }
        ]]
    local pages = {}
    for k, v in ipairs(value[1]) do
      local vType = type(v)
      pages[k] = (vType == "string" or vType == "table") and
      loadlayout(v, views) or v
    end
    view.setAdapter(LuaPagerAdapter(pages, value[2]))
  end,
  background = function(view, value, valueType)
    if valueType == "string" then
      if stringSub(value, 1, 1) == "?" then
        view.setBackgroundResource(activity.getResources().getIdentifier(stringSub(value, 2), nil, nil))
       elseif stringSub(value, 1, 1) == "#" then
        view.setBackgroundColor(parseColor(value))
       else
        if stringFind(value, "%.9%.png$") then
          view.setBackground(NineBitmapDrawable(value))
         else
          view.setBackground(LuaBitmapDrawable(activity, value))
        end
      end
     else
      view.setBackground(value)
    end
  end,
  onClick = function(view, value, valueType, layoutParams, views)
    view.onClick = valueType == "string" and function(v)
      (views[value] or _G[value])(v)
    end or value
  end,
  onLongClick = function(view, value, valueType, layoutParams, views)
    view.onLongClick = valueType == "string" and function(v)
      (views[value] or _G[value])(v)
    end or value
  end,
  src = function(view, value)
    local firstChar = stringSub(value, 1, 1)
    if firstChar ~= "/"
      and stringFind(value, "http") == nil then
      value = this.getLuaDir() .. "/" .. value
    end
    local options = RequestOptions().skipMemoryCache(true).diskCacheStrategy(DiskCacheStrategy.NONE)
    Glide.with(this).load(value).apply(options).into(view)
  end,
  gravity = function(view, value)
    view.setGravity(parseConstants(value, gravityConstants))
  end,
  text = function(view, value)
    view.setText(value)
  end,
  tag = function(view, value)
    view.setTag(value)
  end,
  title = function(view, value)
    view.setTitle(value)
  end,
  subtitle = function(view, value)
    view.setSubtitle(value)
  end,
  hint = function(view, value)
    view.setHint(value)
  end,
  summary = function(view, value)
    view.setSummary(value)
  end,
  textAppearance = function(view, value)
    view.setTextAppearance(activity, value)
  end,
  url = function(view, value)
    view.loadUrl(value)
  end,
  tooltip = function(view, value)
    TooltipCompat.setTooltipText(view, value)
  end,
  textStyle = function(view, value)
    if value == "italic|bold" or value == "bold|italic" then
      view.setTypeface(nil, Typeface.BOLD_ITALIC)
     else
      view.setTypeface(nil, Typeface[stringUpper(value)])
    end
  end,
  scaleType = function(view, value)
    view.setScaleType(scaleTypeEnum[scaleTypeConstants[value]] or tonumber(value))
  end,
  ellipsize = function(view, value)
    view.setEllipsize(TruncateAt[stringUpper(value)])
  end,
  layoutDirection = function(view, value)
    view.setLayoutDirection(viewConstants[value] or tonumber(value))
  end,
  imeOptions = function(view, value)
    view.setImeOptions(viewConstants[value] or tonumber(value))
  end,
  inputType = function(view, value)
    view.setInputType(viewConstants[value] or tonumber(value))
  end,
  textAlignment = function(view, value)
    view.setTextAlignment(viewConstants[value] or tonumber(value))
  end,
  autoLink = function(view, value)
    view.setAutoLink(viewConstants[value] or tonumber(value))
  end,
  scrollbarStyle = function(view, value)
    view.setScrollbarStyle(viewConstants[value] or tonumber(value))
  end,
  textSize = function(view, value, valueType)
    local size = tonumber(value)
    if size then
      view.setTextSize(unitConstants.px, size)
     else
      local num, unit = stringMatch(value, "([%+%-]?[%d%.]+)([%%%a]+)")
      view.setTextSize(unitConstants[unit], tonumber(num))
    end
  end,
  radius = function(view, value)
    view.setRadius(parseSize(value))
  end,
  cardElevation = function(view, value)
    view.setCardElevation(parseSize(value))
  end,
  elevation = function(view, value)
    view.setElevation(parseSize(value))
  end,
  strokeWidth = function(view, value)
    view.setStrokeWidth(parseSize(value))
  end,
  minHeight = function(view, value)
    view.setMinimumHeight(parseSize(value))
  end,
  minWidth = function(view, value)
    view.setMinimumWidth(parseSize(value))
  end,
  textColor = function(view, value)
    view.setTextColor(parseColor(value))
  end,
  backgroundColor = function(view, value)
    view.setBackgroundColor(parseColor(value))
  end,
  password = function(view, value)
    view.setInputType(
    (value == true or value == "true") and
    0x81 or 0x00
    )
  end,
  drawingCacheQuality = function(view, value)
    view.setDrawingCacheQuality(
    value == "auto" and 0 or
    value == "low" and 1 or
    value == "high" and 2 or
    tonumber(value)
    )
  end,
  orientation = function(view, value)
    view.setOrientation(
    value == "vertical" and 1 or
    value == "horizontal" and 0 or
    tonumber(value)
    )
  end,
  importantForAccessibility = function(view, value)
    view.setImportantForAccessibility(
    value == "auto" and 0 or
    value == "yes" and 1 or
    value == "no" and 2 or
    tonumber(value)
    )
  end,
  layerType = function(view, value)
    view.setLayerType(
    value == "none" and 0 or
    value == "software" and 1 or
    value == "hardware" and 2 or
    tonumber(value)
    )
  end,
  visibility = function(view, value)
    view.setVisibility(
    value == "visible" and 0 or
    value == "invisible" and 4 or
    value == "gone" and 8 or
    tonumber(value)
    )
  end,
  layout_collapseMode = function(view, value, valueType, layoutParams)
    layoutParams.setCollapseMode(
    value == "pin" and 1 or
    value == "parallax" and 2 or
    tonumber(value)
    )
  end,
  layout_anchor = function(view, value, valueType, layoutParams, views)
    layoutParams.setAnchorId(rawget(views, value).getId())
  end,
  layout_collapseParallaxMultiplier = function(view, value, valueType, layoutParams)
    layoutParams.setParallaxMultiplier(tonumber(value))
  end,
  layout_behavior = function(view, value, valueType, layoutParams)
    local behavior = layoutBehaviorConstants[value]
    if behavior then
      layoutParams.setBehavior(newInstance(behavior))
     else
      layoutParams.setBehavior(value)
    end
  end,
  layout_weight = function(view, value, valueType, layoutParams)
    layoutParams.weight = tonumber(value)
  end,
  layout_gravity = function(view, value, valueType, layoutParams)
    layoutParams.gravity = parseConstants(value, gravityConstants)
  end,
  layout_scrollFlags = function(view, value, valueType, layoutParams)
    layoutParams.setScrollFlags(parseConstants(value, viewConstants))
  end,
  layout_marginStart = function(view, value, valueType, layoutParams)
    layoutParams.setMarginStart(parseSize(value))
  end,
  layout_marginEnd = function(view, value, valueType, layoutParams)
    layoutParams.setMarginEnd(parseSize(value))
  end,
  onCreate = function(view, value, valueType, layoutParams)
    value(view, layoutParams)
  end,
}

--- 给控件设置属性
---@param view View 需要设置的控件实例
---@param attribute string 需要设置的属性
---@param value any 属性的值
---@param layoutParams LayoutParams 控件的LayoutParams
---@param views table 存储控件实例的表
local function setAttribute(view, attribute, value, layoutParams, views)
  local valueType = type(value)

  local rule = ruleConstants[attribute]
  if rule then
    if value == true or value == "true" then
      layoutParams.addRule(rule)
     else
      layoutParams.addRule(rule, rawget(views, value).getId())
    end
    return
  end

  local setter = attributeSetterMap[attribute]
  if setter then
    setter(view, value, valueType, layoutParams, views)
    return
  end

  -- 判断是否是LayoutParams的属性
  local layoutParamsAttribute = stringMatch(attribute, "layout_(%a+)")
  if layoutParamsAttribute then
    attribute = layoutParamsAttribute
    view = layoutParams
  end

  if valueType == "table" then
    -- table类型的属性没法省略set
    view["set" .. stringGsub(attribute, "^(%a)", stringUpper)](parseValues(value))
   else
    -- 尝试调用setter
    local success, err = pcall(function()
      view["set" .. stringGsub(attribute, "^(%a)", stringUpper)](parseValue(value))
    end)
    if not success then
      -- 尝试直接赋值
      view[attribute] = parseValue(value)
    end
  end
end

--- 设置控件的内边距
---@param layout: table
---@param view: View
local function setPadding(layout, view)
  local padding = layout.padding
  local paddingHorizontal = layout.paddingHorizontal or padding
  local paddingVertical = layout.paddingVertical or padding
  local paddingLeft = layout.paddingLeft or paddingHorizontal
  local paddingTop = layout.paddingTop or paddingVertical
  local paddingRight = layout.paddingRight or paddingHorizontal
  local paddingBottom = layout.paddingBottom or paddingVertical
  local paddingStart = layout.paddingStart
  local paddingEnd = layout.paddingEnd
  if paddingStart or paddingEnd then
    view.setPaddingRelative(
    parseSize(paddingStart or 0),
    parseSize(paddingTop or 0),
    parseSize(paddingEnd or 0),
    parseSize(paddingBottom or 0)
    )
   elseif paddingLeft or paddingTop or paddingRight or paddingBottom then
    view.setPadding(
    parseSize(paddingLeft or 0),
    parseSize(paddingTop or 0),
    parseSize(paddingRight or 0),
    parseSize(paddingBottom or 0)
    )
  end
end

--- 设置控件的外边距
---@param layout: table
---@param layoutParams: ViewGroup.LayoutParams
local function setMargins(layout, layoutParams)
  local layoutMargin = layout.layout_margin
  local layoutMarginHorizontal = layout.layout_marginHorizontal or layoutMargin
  local layoutMarginVertical = layout.layout_marginVertical or layoutMargin
  local layoutMarginLeft = layout.layout_marginLeft or layoutMarginHorizontal
  local layoutMarginTop = layout.layout_marginTop or layoutMarginVertical
  local layoutMarginRight = layout.layout_marginRight or layoutMarginHorizontal
  local layoutMarginBottom = layout.layout_marginBottom or layoutMarginVertical
  if layoutMarginLeft or layoutMarginTop or layoutMarginRight or layoutMarginBottom then
    layoutParams.setMargins(
    parseSize(layoutMarginLeft or 0),
    parseSize(layoutMarginTop or 0),
    parseSize(layoutMarginRight or 0),
    parseSize(layoutMarginBottom or 0)
    )
  end
end

--- 创建并初始化视图
---@param layout: table
---@return View
---@return ViewGroup.LayoutParams
local function createView(layout, views, parentViewClass)
  local viewClass
  local view = assert(layout[1], "missing first value in layout table")
  local theme = layout.theme
  local style = layout.style
  local context = theme and
  ContextThemeWrapper(activity, theme) or
  activity

  if style and type(style) == "string" then
    style = stringSub(style, 1, 1) == "?" and
    activity.getResources().getIdentifier(stringSub(style, 2), "attr", activity.getPackageName()) or
    activity.getResources().getIdentifier(style, "style", activity.getPackageName())
    assert(style ~= 0, "Unknown style " .. layout.style)
  end

  if instanceof(view, View) then
    viewClass = view.class
   else
    viewClass = view
    view = style and
    viewClass(context, nil, style) or
    viewClass(context)
  end

  view.setId(layout.viewId or View.generateViewId())
  local id = layout.id
  if id then
    views[id] = view
  end

  local layoutParams = (parentViewClass or ViewGroup).LayoutParams(
  parseSize(layout.layout_width or -2),
  parseSize(layout.layout_height or -2)
  )

  setMargins(layout, layoutParams)
  setPadding(layout, view)

  return view, layoutParams, viewClass
end

--- 获取布局表
---@param layout: table|string|userdata
---@return table
local function getLayoutTable(layout)
  if type(layout) == "string" then
    layout = require(layout)
  end
  if type(layout) == "table" then
    return layout
   elseif type(layout) == "userdata" then
    local success, result = pcall(luajava.astable, layout)
    if success then return result end
  end
  error("bad argument #1 to 'loadlayout' (table expected, got " .. type(layout) .. ")", 2)
end

--- 将布局表转换为视图实例
---@param layout table 布局表
---@param views table 存储控件实例的表
---@param parentViewClass ViewGroup 父控件的类
function loadlayout(layout, views, parentViewClass)
  layout = getLayoutTable(layout)
  views = views or _G
  local view, layoutParams, viewClass = createView(layout, views, parentViewClass)

  for k, v in pairs(layout) do
    if excludeAttributes[k] then
      goto _continue_
    end
    if type(k) == "number" then
      -- 添加子控件
      view.addView(
      instanceof(v, View) and
      v or loadlayout(v, views, viewClass)
      )
     else
      -- 设置属性并且处理报错
      local e, s = pcall(setAttribute, view, k, v, layoutParams, views)
      if not e then
        local _, i = stringFind(s, ":%d+:")
        s = stringSub(s, i or 1)
        local _, du = pcall(dump, layout)
        error(stringFormat("loadlayout error %s \n\tat %s\n\tat  key=%s value=%s\n\tat %s", s, tostring(view), k, v, du or ""), 0)
      end
    end
::_continue_::
  end

  view.setLayoutParams(layoutParams)
  return view
end

return loadlayout
