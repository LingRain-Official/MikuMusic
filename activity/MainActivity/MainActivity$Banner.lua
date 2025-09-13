local LinearLayoutManager = luajava.bindClass "androidx.recyclerview.widget.LinearLayoutManager"
local Glide = luajava.bindClass "com.bumptech.glide.Glide"
local LuaCustRecyclerAdapter = luajava.bindClass "com.lua.custrecycleradapter.LuaCustRecyclerAdapter"
local AdapterCreator = luajava.bindClass "com.lua.custrecycleradapter.AdapterCreator"
local LuaCustRecyclerHolder = luajava.bindClass "com.lua.custrecycleradapter.LuaCustRecyclerHolder"
--import "com.to.aboomy.pager2banner.IndicatorView"
import "com.to.aboomy.pager2banner.ScaleInTransformer"
local imagePath = {
  activity.getLuaDir().."/res/image/AdachiRei.jpg",
  activity.getLuaDir().."/res/image/HatsuneMiku1.jpg",
  activity.getLuaDir().."/res/image/HatsuneMiku2.jpg",
  activity.getLuaDir().."/res/image/HatsuneMiku4.jpg",
}

local adp10 = LuaCustRecyclerAdapter(AdapterCreator({
  getItemCount = function() return #imagePath end,
  onCreateViewHolder = function(parent, viewType)
    local views = {}
    local holder = LuaCustRecyclerHolder(loadlayout("res.layout.item_banner", views))
    holder.view.setTag(views)
    return holder
  end,
  onBindViewHolder = function(holder, position)
    local view = holder.view.getTag()
    local index = position + 1
    Glide.with(activity).load(imagePath[index]).into(view.img)
  end,
}))

local function dip2px(dpValue)
  local scale = activity.getResources().getDisplayMetrics().density
  return dpValue * scale + 0.5
end

banner.setAdapter(adp10, 1)
banner.addPageTransformer(ScaleInTransformer())
banner.setPageMargin(dip2px(15), dip2px(10))