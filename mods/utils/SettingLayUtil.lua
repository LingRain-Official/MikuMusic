require "env"
local LinearLayoutManager = luajava.bindClass "androidx.recyclerview.widget.LinearLayoutManager"
local LuaCustRecyclerAdapter = luajava.bindClass "com.lua.custrecycleradapter.LuaCustRecyclerAdapter"
local AdapterCreator = luajava.bindClass "com.lua.custrecycleradapter.AdapterCreator"
local LuaCustRecyclerHolder = luajava.bindClass "com.lua.custrecycleradapter.LuaCustRecyclerHolder"
local apply= luajava.bindClass
local _M = {}
local AppCompatTextView = apply "androidx.appcompat.widget.AppCompatTextView"
local LinearLayoutCompat = apply "androidx.appcompat.widget.LinearLayoutCompat"
local MaterialSwitch = apply "com.google.android.material.materialswitch.MaterialSwitch"
local AppCompatImageView = apply "androidx.appcompat.widget.AppCompatImageView"
local Glide = apply "com.bumptech.glide.Glide"
local MaterialDivider = apply "com.google.android.material.divider.MaterialDivider"
local ColorStateList = apply"android.content.res.ColorStateList"
--一些全局函数
function dp2px(dpValue)
  local scale = activity.getResources().getDisplayMetrics().density
  return Math.round(dpValue * scale)
end

function getRipple(i,RippleColor)
  local attrs = {i and android.R.attr.selectableItemBackgroundBorderless or android.R.attr.selectableItemBackground}
  local ripple = this.obtainStyledAttributes(attrs).getResourceId(0,0)
  local drawable = this.Resources.getDrawable(ripple)
  drawable.setColor(ColorStateList.valueOf(RippleColor))
  return drawable
end
local ITEM_H = dp2px(68)--item高度
_M.TITLE = 1
_M.ITEM = 2
_M.ITEM_NOMESSAGE = 3
_M.ITEM_NOICON = 4
_M.ITEM_SWITCH = 5
_M.ITEM_SWITCH_NOICON = 6
_M.ITEM_SWITCH_NOMESSAGE = 7
_M.DIVIDER = 8
_M.RADIUSITEM = 9
--一些布局模块
local leftIconMod = {
  AppCompatImageView,
  layout_width="24dp",
  layout_height="24dp",
  ColorFilter=Colors.colorPrimary,
  id="icon",
  layout_marginRight="11dp";
}
local leftRadiusIconMod =
{
  MaterialCardView;
  radius="17.5dp",
  {
    AppCompatImageView,
    layout_width="35dp",
    layout_height="35dp",
    --ColorFilter=colorPrimary,
    id="icon",
  },

}
local titleAndMessageMod = {
  LinearLayoutCompat,
  layout_weight=1,
  orientation=1,
  layout_marginStart="20dp",
  layout_marginEnd="20dp",
  {
    AppCompatTextView,
    id="title",
    textSize="16sp",
    textColor=Colors.colorOnBackground,
    textStyle="bold",
    layout_marginTop="15dp";
  },
  {
    AppCompatTextView,
    layout_marginTop="1dp",
    id="message",
    textSize="12sp",
    textColor=Colors.colorOutline,
    layout_marginBottom="15dp";
  },
}

local titleMod = {
  AppCompatTextView,
  id="title",
  textSize="16sp",
  textColor=Colors.colorOnBackground,
  textStyle="bold",
  layout_weight=1,
  layout_marginStart="20dp",
  layout_marginEnd="20dp",
  layout_marginBottom="15dp";
  layout_marginTop="15dp";
}

local rightSwitchMod = {
  MaterialSwitch,
  id="switch_",
}

--一些布局

local divider = {
  MaterialDivider,
  layout_width=-1,
}

local item_title = {
  LinearLayoutCompat,
  {
    AppCompatTextView,
    textColor=Colors.colorPrimary,
    layout_marginStart="20dp",
    layout_margin="12dp",
    textStyle="bold",
    id="title",
  },
}

local item = {
  LinearLayoutCompat,
  gravity="center",
  layout_width=-1,
  paddingStart="20dp",
  paddingEnd="20dp",
  --layout_height=ITEM_H,
  leftIconMod,
  titleAndMessageMod,
}
local RadiusItem = {
  LinearLayoutCompat,
  gravity="center",
  layout_width=-1,
  paddingStart="20dp",
  paddingEnd="20dp",
  --layout_height=ITEM_H,
  leftRadiusIconMod,
  titleAndMessageMod,
}
local item_no_message = {
  LinearLayoutCompat,
  gravity="center",
  layout_width=-1,
  paddingStart="20dp",
  paddingEnd="20dp",
  layout_height=ITEM_H,

  leftIconMod,
  titleMod,
}

local item_no_icon = {
  LinearLayoutCompat,
  gravity="center",
  layout_width=-1,
  paddingStart="20dp",
  paddingEnd="20dp",
  --layout_height=ITEM_H,

  titleAndMessageMod,
}

local item_switch = {
  LinearLayoutCompat,
  gravity="center",
  layout_width=-1,
  paddingStart="20dp",
  paddingEnd="20dp",
  --layout_height=ITEM_H,

  leftIconMod,
  titleAndMessageMod,
  rightSwitchMod,
}

local item_switch_no_message = {
  LinearLayoutCompat,
  gravity="center",
  layout_width=-1,
  paddingStart="20dp",
  paddingEnd="20dp",
  layout_height=ITEM_H,

  leftIconMod,
  titleMod,
  rightSwitchMod,
}

local item_switch_no_icon = {
  LinearLayoutCompat,
  gravity="center",
  layout_width=-1,
  paddingStart="20dp",
  paddingEnd="20dp",
  --layout_height=ITEM_H,

  titleAndMessageMod,
  rightSwitchMod,
}

--整一起
local layouts = {
  [_M.TITLE] = item_title,
  [_M.RADIUSITEM] = RadiusItem,
  [_M.ITEM] = item,
  [_M.ITEM_NOMESSAGE] = item_no_message,
  [_M.ITEM_NOICON] = item_no_icon,
  [_M.ITEM_SWITCH] = item_switch,
  [_M.ITEM_SWITCH_NOMESSAGE] = item_switch_no_message,
  [_M.ITEM_SWITCH_NOICON] = item_switch_no_icon,
  [_M.DIVIDER] = divider,
}

--传入布局数据
function _M.newAdapter(data)
  return LuaCustRecyclerAdapter(AdapterCreator{
    getItemCount=function()
      return #data
    end,
    getItemViewType=function(position)
      return data[position+1][1]
    end,
    onCreateViewHolder=function(parent,viewType)
      local view = {}
      local holder = LuaCustRecyclerHolder(loadlayout(layouts[viewType], view))

      if view.switch_
        holder.view.onClick=function()
          view.switch_.setChecked(not view.switch_.isChecked())
        end
      end

      holder.view.setBackground(getRipple(false,RippleColor))
      holder.view.setTag(view)

      return holder
    end,
    onBindViewHolder=function(holder,position)
      local view = holder.view.getTag()
      local data = data[position+1]

      if data.title
        view.title.setText(data.title)
      end

      if data.message
        view.message.setText(data.message)
      end

      if data.icon
        Glide.with(this).load(data.icon).into(view.icon)
      end

      if data.onClick
        holder.view.onClick = data.onClick
      end

      if data.checked
        view.switch_.setChecked(data.checked)
      end
      if data.event
        view.switch_.setOnCheckedChangeListener{
          onCheckedChanged=function(view,checked)
            data.event(view, checked)
          end
        }
      end

    end,
  })
end


return _M