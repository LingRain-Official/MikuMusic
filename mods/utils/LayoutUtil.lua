local _M = {}
local ltrs={}

local context = activity
local bind = luajava.bindClass
local instanceOf = luajava.instanceof
local Number = tonumber
local matches = string.match
local sub = string.sub
local ConstTable = table.const
local insert = table.insert
local metrics = context.resources.displayMetrics
local density = metrics.density
local scaledDensity = metrics.scaledDensity
local xdpi = metrics.xdpi
local luadir = context.getLuaDir()
local loadbitmap = require "loadbitmap"

local ScaleType = bind "android.widget.ImageView$ScaleType"
local ViewGroup = bind "android.view.ViewGroup"
local View = bind "android.view.View"
local TypedValue = bind "android.util.TypedValue"
local TooltipCompat = bind "androidx.appcompat.widget.TooltipCompat"
local ContextThemeWrapper = bind "androidx.appcompat.view.ContextThemeWrapper"
local ViewStubCompat = bind "androidx.appcompat.widget.ViewStubCompat"
local TruncateAt = bind "android.text.TextUtils$TruncateAt"

local PagerAdapter
pcall(function()
  PagerAdapter = PagerAdapter or bind "github.daisukiKaffuChino.LuaPagerAdapter"
end)

_G.Include = ConstTable {}

luajava.ids = luajava.ids or { id = 0x7f000000 }
local ids = luajava.ids
local scaleTypeEnum = ScaleType.values()

-- Compatible with .aly
table.insert(package.searchers, function(path)
  local alypath=package.path:gsub("%.lua;",".aly;")
  local path, msg = package.searchpath(path, alypath)
  if msg
    return msg
  end
  local f=io.open(path)
  local s=f:read("*a")
  f:close()
  if string.sub(s,1,4)=="\27Lua"
    return assert(loadfile(path)),path
   else
    local f,st=loadstring("return "..s, path:match("[^/]+/[^/]+$"),"bt")
    if st
      error(st:gsub("%b[]",path,1),0)
    end
    return f,st
  end
end)

table.insert(package.searchers, function(path)
  local alyxPath = package.path:gsub("%.lua;", ".alyx;")
  local path, msg = package.searchpath(path, alyxPath)
  if msg return msg end
  return assert(loadfile(path)), path
end)

_M.import = function(path)
  local alyxPath = package.path:gsub("%.lua;", ".alyx;")
  local path, msg = package.searchpath(path, alyxPath)
  if msg return msg end
  return loadfile(path)()
end

local CONSTANTS_MEASUREMENT = {
  match_parent = -1,
  fill_parent = -1,
  wrap_content = -2,

  match = -1,
  fill = -1,
  wrap = -2,
}

local CONSTANTS_GRAVITY = ConstTable {
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
  "end" = 8388613,
}

local CONSTANTS = {
  -- orientation
  vertical = 1,
  horizontal = 0,

  -- layout_collapseMode
  pin = 1,
  parallax = 2,

  -- layout_scrollFlags
  noScroll = 0,
  scroll = 1,
  exitUntilCollapsed = 2,
  enterAlways = 4,
  enterAlwaysCollapsed = 8,
  snap = 16,
  snapMargins = 32,

  -- visibility
  visible = 0,
  invisible = 4,
  gone = 8,

  scaleType = ConstTable {
    matrix = 0,
    fitXY = 1,
    fitStart = 2,
    fitCenter = 3,
    fitEnd = 4,
    center = 5,
    centerCrop = 6,
    centerInside = 7,
  },

  relativeRules = ConstTable {
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
}


local UNITS = ConstTable {
  px = 0,
  dp = 1,
  sp = 2,
  pt = 3,
  mm = 5,
  "in" = 4
}

local UNITS_CONVERTER = ConstTable {
  px = function(v)
    return v
  end,
  dp = function(v)
    return v * density + 0.5
  end,
  sp = function(v)
    return v * scaledDensity + 0.5
  end,
  pt = function(v)
    return xdpi * v * 0.013888889
  end,
  mm = function(v)
    return xdpi * value * 0.03937008
  end,
  cm = function(v)
    return xdpi * value * 0.3937008
  end,
  "in" = function(v)
    return xdpi * value
  end,

  ---@Deprecated
  "%w" = function(v)
    return v / 100 * activity.width
  end,
  "%h" = function(v)
    return v / 100 * activity.height
  end
}


local IGNORED_ATTRS = ConstTable {
  id = 0,
  viewId = 0,
  style = 0,
  theme = 0,
  layout_width = 0,
  layout_height = 0,

  padding = 0,
  paddingLeft = 0,
  paddingRight = 0,
  paddingTop = 0,
  paddingBottom = 0,
  paddingStart = 0,
  paddingEnd = 0,
  paddingVertical = 0,
  paddingHorizontal = 0,

  layout_margin = 0,
  layout_marginLeft = 0,
  layout_marginRight = 0,
  layout_marginTop = 0,
  layout_marginBottom = 0,
  layout_marginVertical = 0,
  layout_marginHorizontal = 0,

  layoutParams = 0,
  base = 0,
  meta = 0,
  let = 0,
}

local customAttrs = {}
local customPreAttrs = {}

local function throw(baseStr, value)
  error(baseStr:format(value), -1)
end

local function measure(value)
  local unitConverter = UNITS_CONVERTER[sub(value, -2, -1)]
  if unitConverter
    return unitConverter(sub(value, 1, -3))
  end
end

local function getSpec(value)
  if type(value) == "string"
    return CONSTANTS_MEASUREMENT[value] or measure(value)
   else
    return value
  end
end

local function toConstant(value, t)
  if type(value) == "number" return value end
  local ret = 0
  for n in (value.."|"):gmatch("(.-)|")
    local s = t[n]
    if t[n]
      ret = ret | s
     else
      return nil
    end
  end
  return ret
end

local function hexStrToHex(str)
  if not str
    return nil
  end
  if string.sub(str, 1, 1) == "#"
    return tonumber("0x"..string.sub(str, 2))
   else
    return tonumber(str)
  end
end

local function setBackgroundColor(view, bg)
  local ColorDrawable = bind "android.graphics.drawable.ColorDrawable"
  if bind "android.os.Build".VERSION.SDK_INT < 16
    view.setBackgroundDrawable(ColorDrawable(hexStrToHex(bg)))
   else
    view.setBackgroundColor(hexStrToHex(bg))
  end
end

local function getIdentifier(name)
  return context.getResources().getIdentifier(name,nil,nil)
end

local function checkType(v)
  local n, ty = string.match(v, "^(%-?[%.%d]+)(%a%a)$")
  return tonumber(n), UNITS[ty]
end

local function setAttribute(view, k, v, params, t, inflator, parent, parentT, parentInflator)
local valueType = type(v)
when v == null v = nil

  if k == "layout_x"
    params.x = getSpec(v)

   elseif k == "layout_y"
    params.y = getSpec(v)

   elseif k == "layout_scrollFlags"
    params.setScrollFlags(toConstant(v, CONSTANTS))

   elseif k == "layout_weight"
    params.weight = v

   elseif k == "w"
    params.width = getSpec(v)

   elseif k == "h"
    params.height = getSpec(v)

   elseif k == "layout_gravity"
    params.gravity = toConstant(v, CONSTANTS_GRAVITY)

   elseif k == "layout_marginStart"
    params.setMarginStart(measure(v) or v)

   elseif k == "layout_marginEnd"
    params.setMarginEnd(measure(v) or v)

   elseif k=="behavior_hideable"
    if params.getBehavior()
      params.getBehavior().setHideable(getSpec(v))
     else
      task(1,function()
        params.getBehavior().setHideable(getSpec(v))
      end)
    end

   elseif k=="behavior_skipCollapsed"
    if params.getBehavior()
      params.getBehavior().setSkipCollapsed(getSpec(v))
     else
      task(1,function()
        params.getBehavior().setSkipCollapsed(getSpec(v))
      end)
    end

   elseif k=="layout_collapseMode"
    params.setCollapseMode(toConstant(v, CONSTANTS))

   elseif k=="layout_collapseParallaxMultiplier"
    params.setParallaxMultiplier(getSpec(v))

   elseif k=="layout_anchor"
    params.setAnchorId(ids[v])

   elseif k=="layout_behavior"
    if tostring(v) == "@string/appbar_scrolling_view_behavior" or tostring(v) == "appbar_scrolling_view_behavior"
      local ScrollingViewBehavior = luajava.newInstance "com.google.android.material.appbar.AppBarLayout$ScrollingViewBehavior"
      params.setBehavior(ScrollingViewBehavior)
     elseif tostring(v) == "@string/bottom_sheet_behavior" or tostring(v) == "bottom_sheet_behavior"
      local mBottomSheetBehavior = luajava.newInstance "com.google.android.material.bottomsheet.BottomSheetBehavior"
      params.setBehavior(mBottomSheetBehavior)
     else
      params.setBehavior(v)
    end

   elseif (CONSTANTS.relativeRules[k] && v)
    params.addRule(CONSTANTS.relativeRules[k])

   elseif CONSTANTS.relativeRules[k]
    params.addRule(CONSTANTS.relativeRules[k], ids[v])

   elseif k == "textSize"
    if Number(v)
      view.setTextSize(tonumber(v))
     elseif type(v) == "string"
      local n, ty = checkType(v)
      if ty
        view.setTextSize(ty, n)
       else
        view.setTextSize(v)
      end
     else
      view.setTextSize(v)
    end

   elseif k == "items"

    local ArrayListAdapter = bind "android.widget.ArrayListAdapter"
    local String = bind "java.lang.String"

    if type(v) == "table"
      if view.adapter
        view.adapter.addAll(v)
       else
        local adapter = ArrayListAdapter(context, android.R.layout.simple_list_item_1, String(v))
        view.setAdapter(adapter)
      end
     elseif type(v) == "function"
      if view.adapter
        view.adapter.addAll(v())
       else
        local adapter = ArrayListAdapter(context, android.R.layout.simple_list_item_1, String(v()))
        view.setAdapter(adapter)
      end
     elseif type(v) == "string"
      local v = rawget(root, v) or rawget(_G, v)
      if view.adapter
        view.adapter.addAll(v())
       else
        local adapter = ArrayListAdapter(context, android.R.layout.simple_list_item_1, String(v()))
        view.setAdapter(adapter)
      end
    end

   elseif k == "pages" and type(v) == "table" --创建页项目
    xpcall(function()

      local ArrayList = bind "java.util.ArrayList"
      local BasePagerAdapter = bind "android.widget.BasePagerAdapter"

      local views = ArrayList()
      for n, o ipairs(v)
        local tp = type(o)
        if tp == "string" or tp == "table"
          views.add(inflate(o, root))
         else
          views.add(o)
        end
      end
      view.setAdapter(BasePagerAdapter(views))

      end,function()

      local ArrayPageAdapter = bind "android.widget.ArrayPageAdapter"

      local ps = {}
      for n,o ipairs(v)
        local tp = type(o)
        if tp == "string" or tp == "table"
          table.insert(ps,inflate(o,root))
         else
          table.insert(ps,o)
        end
      end
      local adapter = ArrayPageAdapter(View(ps))
      view.setAdapter(adapter)

    end)

   elseif k=="pagesWithTitle" and type(v)=="table" --创建带标题的页项目
    local BasePagerAdapter = bind "android.widget.BasePagerAdapter"
    local list={}
    for n,o ipairs(v[1])
      local tp=type(o)
      if tp=="string" or tp=="table"
        list[n]=inflate(o,root)
       else
        list[n]=o
      end
    end
    view.setAdapter(BasePagerAdapter(list,v[2]))

   elseif k == "textStyle"

    local Typeface = bind "android.graphics.Typeface"

    if v=="bold"
      local bold = Typeface.defaultFromStyle(Typeface.BOLD)
      view.setTypeface(bold)
     elseif v=="normal"
      local normal = Typeface.defaultFromStyle(Typeface.NORMAL)
      view.setTypeface(normal)
     elseif v=="italic"
      local italic = Typeface.defaultFromStyle(Typeface.ITALIC)
      view.setTypeface(italic)
     elseif v=="italic|bold" or v=="bold|italic"
      local bold_italic = Typeface.defaultFromStyle(Typeface.BOLD_ITALIC)
      view.setTypeface(bold_italic)
    end

   elseif k == "textAppearance"
    view.setTextAppearance(context, v)

   elseif k == "ellipsize"
    view.setEllipsize(TruncateAt[string.upper(v)])

   elseif k == "url"
    view.loadUrl(v)

   elseif k == "src"
    _M.loadImage(view, v)

   elseif k == "scaleType"
    view.setScaleType(scaleTypeEnum[CONSTANTS.scaleType[v]] or v)

   elseif k == "backgroundColor" or k == "BackgroundColor"
    setBackgroundColor(view, v)

   elseif k == "background" or k == "Background"
    if type(v)=="string"
      if v:find("^%?")
        view.setBackgroundResource(getIdentifier(v:sub(2,-1)))
       elseif v:find("^#") or v:find("0x") or v:find("0X")
        view.setBackgroundColor(hexStrToHex(v))
       elseif rawget(root,v) or rawget(_G,v)
        v=rawget(root,v) or rawget(_G,v)
        if type(v)=="function"
          local LuaDrawable = bind "com.androlua.LuaDrawable"
          view.setBackground(LuaDrawable(v))
         elseif type(v)=="userdata"
          view.setBackground(v)
        end
       else

        if (not v:find("^/")) and luadir
          v=luadir..v
        end
        if v:find("%.9%.png")
          local NineBitmapDrawable = bind "com.androlua.NineBitmapDrawable"
          view.setBackground(NineBitmapDrawable(loadbitmap(v)))
         else
          local LuaBitmapDrawable = bind "com.androlua.LuaBitmapDrawable"
          view.setBackground(LuaBitmapDrawable(context,v))
        end
      end

     elseif type(v)=="userdata"
      view.setBackground(v)
     elseif type(v)=="number"
      view.setBackground(v)
    end

   elseif k == "CardBackgroundColor" or k == "cardBackgroundColor" or k == "cardbackgroundColor"
    view.setCardBackgroundColor(hexStrToHex(v))

   elseif (k == "password" && v)
    view.setInputType(0x81)

   elseif k == "tag"
    view.setTag(v)

   elseif k == "text"
    view.setText(v)

   elseif k == "title"
    view.setTitle(v)

   elseif k == "subtitle"
    view.setSubtitle(v)

   elseif k == "TooltipText" or k == "tooltipText"
    TooltipCompat.setTooltipText(view, v)

   elseif k == "hint"
    view.setHint(v)

   elseif k == "summary"
    view.setSummary(v)

   elseif k == "gravity"
    view.setGravity(toConstant(v, CONSTANTS_GRAVITY) or v)

   elseif k == "orientation"
    view.setOrientation(CONSTANTS[v] or v)

   elseif k == "onClick"
    local OnClickListener = bind "android.view.View$OnClickListener"
    local listener
    if type(v) == "function"
      listener = OnClickListener { onClick = v }

     elseif type(v) == "userdata"
      listener = v

     elseif type(v) == "string"

      if ltrs[v]
        listener = ltrs[v]
       else
        local l = rawget(root, v) or rawget(_G, v)
        if type(l) == "function"
          listener = OnClickListener { onClick = l }
         elseif type(l) == "userdata"
          listener = l
         else
          listener = OnClickListener { onClick = function(a) (root[v] or _G[v])(a) end }
        end
        ltrs[v] = listener
      end
    end
    view.setOnClickListener(listener)

   elseif k=="onLongClick"
    local OnLongClickListener = bind "android.view.View$OnLongClickListener"
    local listener
    if type(v)=="function"
      listener=OnLongClickListener{ onLongClick=v }

     elseif type(v)=="userdata"
      listener=v

     elseif type(v)=="string"
      if ltrs[v]
        listener=ltrs[v]
       else
        local l=rawget(root,v) or rawget(_G,v)
        if type(l)=="function"
          listener=OnLongClickListener{ onLongClick=l }
         elseif type(l)=="userdata"
          listener=l
         else
          listener=OnLongClickListener{ onLongClick=function(a) (root[v] or _G[v])(a) end }
        end
        ltrs[v]=listener
      end
    end
    view.setOnLongClickListener(listener)

   else
    if customAttrs[k]
      customAttrs[k](view, v, params, t, inflator, parent, parentT, parentInflator)
     elseif valueType == "table"
      local setter = "set"..k:gsub("^(%w)", string.upper)
      view[setter](table.unpack(v))
     else
      if matches(k, "layout_")
        if valueType == "string"
          v = measure(v) or toConstant(v, CONSTANTS)
        end
        params[(k:gsub("layout_", ""))] = v
       else
        local setter = "set"..k:gsub("^(%w)", string.upper)
        if valueType == "string"
          v = measure(v) or toConstant(v, CONSTANTS) or v
        end
        view[setter](v)
      end
    end
  end
end


local function initView(viewConstructor, t, parent)
  local view
  local base = t.base
  if instanceOf(viewConstructor, View)
    view = viewConstructor
   elseif t.style or t.theme or (base && base.style)
    view = viewConstructor(
    ContextThemeWrapper(context, t.theme or t.style or base.style),
    nil, t.style or ((base or { style = 0 }).style)
    )
   else
    view = viewConstructor(context)
  end

  local params
  if t.layoutParams
    params = t.layoutParams
   else
    params = ViewGroup.LayoutParams(
    getSpec(t.layout_width or (base and base.layout_width) or -2),
    getSpec(t.layout_height or (base and base.layout_height) or -2)
    )
    if parent
      params = parent.LayoutParams(params)
    end
  end


  local margin = t.layout_margin
  local marginLeft = t.layout_marginLeft
  or t.layout_marginHorizontal or margin
  local marginTop = t.layout_marginTop
  or t.layout_marginVertical or margin
  local marginRight = t.layout_marginRight
  or t.layout_marginHorizontal or margin
  local marginBottom = t.layout_marginBottom
  or t.layout_marginVertical or margin

  if (marginLeft || marginTop
    || marginRight || marginBottom)
    params.setMargins(
    getSpec(marginLeft or 0),
    getSpec(marginTop or 0),
    getSpec(marginRight or 0),
    getSpec(marginBottom or 0)
    )
  end


  local padding = t.padding
  local paddingLeft = t.paddingLeft
  or t.paddingHorizontal or padding
  local paddingTop = t.paddingTop
  or t.paddingVertical or padding
  local paddingRight = t.paddingRight
  or t.paddingHorizontal or padding
  local paddingBottom = t.paddingBottom
  or t.paddingVertical or padding

  if (paddingLeft || paddingTop
    || paddingRight || paddingBottom)
    view.setPadding(
    getSpec(paddingLeft or 0),
    getSpec(paddingTop or 0),
    getSpec(paddingRight or 0),
    getSpec(paddingBottom or 0)
    )
  end

  if (t.paddingStart || t.paddingEnd)
    view.setPaddingRelative(
    getSpec(t.paddingStart or padding or 0),
    getSpec(paddingTop or 0),
    getSpec(t.paddingEnd or padding or 0),
    getSpec(paddingBottom or 0))
  end


  return view.setLayoutParams(params), params
end


local function inflate(t, env, parent, rawParent, parentT, parentInflator)
  local view
  local params
  local env = env or _G
  local inflator = {
    onChildrenViewsAddedCallbacks = {}
  }

  if type(t) == "string"
    local v = t
    t = require(t)
    package.loaded[v] = nil
   elseif type(t) ~= "table"
    throw("[Layout.inflate] Error at: %s \n\tThe first argument of the method must be a layout-table or string! ", t)
  end

:: construct ::
  local viewConstructor = t[1]
  if !viewConstructor
    throw("[Layout.inflate] Error at: %s \n\tThe first value of the layout-table must be a View Class, check your imported packages.", dump(t))
   elseif type(viewConstructor) == "table"
    if viewConstructor.__call
      viewConstructor = viewConstructor.__call
     elseif viewConstructor == Include
      if (t.condition && !t.condition())
        return ViewStubCompat(activity, nil)
      end
      if t.init
        return inflate(t.layout, env, parent)
       else
        t = require(t.layout)
        goto construct
      end
    end
  end

  if t.base
    for k, v pairs(t.base)
      t[k] = t[k] or v
    end
  end

  local id = t.id
  local viewId = t.viewId
  local view, params = initView(viewConstructor, t, parent)
  if id
    rawset(env, id, view)
  end
  if viewId
    view.setId(viewId)
   else
    view.setId(View.generateViewId())
  end

  local function addOnChildrenViewsAddedCallback(fn)
    -- print(view, dump(inflator))
    table.insert(inflator.onChildrenViewsAddedCallbacks, fn)
  end
  inflator.addOnChildrenViewsAddedCallback
  = addOnChildrenViewsAddedCallback

  for k, v pairs(t)
    if IGNORED_ATTRS[k] or Number(k)
      continue
     else
      --print(parentInflator)
      --print(parent,parentInflator)
      local e, s = pcall(setAttribute, view, k, v, params, t, inflator, rawParent, parentT, parentInflator)
      if !e
        local a, du = pcall(dump, t)
        --print(du, view.parent, s, k, v)
      end
    end
  end

  for k, v ipairs(t)
    if k == 1 continue end
    view.addView(inflate(v, env, view.class, view, t, inflator))
  end
  --when luajava.instanceof(view, ConstraintLayout)
  --print(view.getChildAt(0))
  for _, v pairs(inflator.onChildrenViewsAddedCallbacks)
    v(view)
  end

  if (t.base && t.base.let)
    t.base.let(view)
  end

  if t.let
    t.let(view)
  end

  return view
end

local function convertConstants(s)
  local t
  if type(s) == "string"
    t = require(s)
    package.loaded[s] = nil
   elseif type(s) ~= "table"
    throw("[Layout.inflate] Error at: %s \n\tThe first argument of the method must be a layout-table or string! ", t)
   else
    t = s
  end
  for k, v pairs(t)
    if k == 1
      continue
     elseif Number(k)
      t[k] = convertConstants(v)
     elseif k == "base"
      for j, i pairs(v)
        t[j] = t[j] or i
      end
      t[k] = nil
     elseif k == "text" || k == "id"
      t[k] = v
     else
      if type(v) == "string"
        t[k] = measure(v)
        or toConstant(v, CONSTANTS)
        or toConstant(v, CONSTANTS_GRAVITY)
        or v
       else
        t[k] = v
        --print(9, k, t[k])
      end
    end
  end

  return t
end


_M.loadImage = function(view, value)

  local Glide = bind "com.bumptech.glide.Glide"

  local path = value
  if not path:find("^/") and path:sub(1, 4) ~= "http"
    local _path = luadir.."/"..path
    if (_path ~= nil)
      path = _path
    end
  end
  Glide.with(this).load(path).into(view)
  --view.setImageBitmap(LuaBitmap.getBitmap(activity, value))

end


_M.apply = function(arg1, arg2)
  local t = arg2 or arg1
  local view = arg2 and arg1 or arg1[1]
  local params = view.layoutParams

  local margin = t.layout_margin
  local marginLeft = t.layout_marginLeft
  or t.layout_marginHorizontal or margin
  local marginTop = t.layout_marginTop
  or t.layout_marginVertical or margin
  local marginRight = t.layout_marginRight
  or t.layout_marginHorizontal or margin
  local marginBottom = t.layout_marginBottom
  or t.layout_marginVertical or margin

  if (marginLeft || marginTop
    || marginRight || marginBottom)
    params.setMargins(
    getSpec(marginLeft or 0),
    getSpec(marginTop or 0),
    getSpec(marginRight or 0),
    getSpec(marginBottom or 0)
    )
  end

  local padding = t.padding
  local paddingLeft = t.paddingLeft
  or t.paddingHorizontal or padding or view.paddingLeft
  local paddingTop = t.paddingTop
  or t.paddingVertical or padding or view.paddingTop
  local paddingRight = t.paddingRight
  or t.paddingHorizontal or padding or view.paddingRight
  local paddingBottom = t.paddingBottom
  or t.paddingVertical or padding or view.paddingBottom

  if (paddingLeft || paddingTop
    || paddingRight || paddingBottom)
    view.setPadding(
    getSpec(paddingLeft or 0),
    getSpec(paddingTop or 0),
    getSpec(paddingRight or 0),
    getSpec(paddingBottom or 0)
    )
  end

  if (t.paddingStart || t.paddingEnd)
    view.setPaddingRelative(
    getSpec(t.paddingStart or padding or 0),
    getSpec(paddingTop or 0),
    getSpec(t.paddingEnd or padding or 0),
    getSpec(paddingBottom or 0))
  end


  for k, v pairs(t)
    if IGNORED_ATTRS[k] or Number(k)
      continue
     else
      setAttribute(view, k, v, params, t)
    end
  end
end

_M.addAttributeResolver = function(k, v)
  customAttrs[k] = v
end

_M.addAttributeResolvers = function(t)
  for k, v pairs(t)
    customAttrs[k] = v
  end
end

_M.addAttributePreResolver = function(k, v)
  customPreAttrs[k] = v
end

_M.addAttributePreResolvers = function(t)
  for k, v pairs(t)
    customPreAttrs[k] = v
  end
end

_M.Internal = {
  CONSTANTS_MEASUREMENT = CONSTANTS_MEASUREMENT,
  IGNORED_ATTRS = IGNORED_ATTRS,
  UNITS_CONVERTER = UNITS_CONVERTER,
  CONSTANTS_GRAVITY = CONSTANTS_GRAVITY,
  UNITS = UNITS,
  toConstant = toConstant,
  getSpec = getSpec,
  measure = measure,
  initView = initView,
  setAttribute = setAttribute
}

_M.initLayout = convertConstants
_M.inflate = inflate
return setmetatable(_M, _M)