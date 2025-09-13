require "env"

local LuaCustRecyclerAdapter = luajava.bindClass "com.lua.custrecycleradapter.LuaCustRecyclerAdapter"
local LuaCustRecyclerHolder = luajava.bindClass "com.lua.custrecycleradapter.LuaCustRecyclerHolder"
local AdapterCreator = luajava.bindClass "com.lua.custrecycleradapter.AdapterCreator"
local LinearLayoutManager = luajava.bindClass "androidx.recyclerview.widget.LinearLayoutManager"

local FileDrawable = require "mods.utils.FileDrawable"
local IconDrawable = require "mods.utils.IconDrawable"
local SettingLayUtil = require "mods.utils.SettingLayUtil"
local MyPopupMenu = require "mods.utils.MyPopupMenu"
local data = require "activity.MusicSettingActivity.MusicSettingActivity$Data"
activity.setContentView(loadlayout("res.layout.activity_musicsetting"))
.setSupportActionBar(toolbar)
.getSupportActionBar()
.setDisplayHomeAsUpEnabled(true)
--.setHomeAsUpIndicator(IconDrawable(activity.getLuaDir().."/res/drawable/bofang.png"))
onOptionsItemSelected = function(v)
  activity.finish()
end

local Recadapter = SettingLayUtil.newAdapter(data)
recyclerView
.setAdapter(Recadapter)
.setLayoutManager(LinearLayoutManager(this))
.setHasFixedSize(true)