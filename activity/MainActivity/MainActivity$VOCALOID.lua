require "env"
local LinearLayoutManager = luajava.bindClass "androidx.recyclerview.widget.LinearLayoutManager"
local Glide = luajava.bindClass "com.bumptech.glide.Glide"
local LuaCustRecyclerAdapter = luajava.bindClass "com.lua.custrecycleradapter.LuaCustRecyclerAdapter"
local AdapterCreator = luajava.bindClass "com.lua.custrecycleradapter.AdapterCreator"
local LuaCustRecyclerHolder = luajava.bindClass "com.lua.custrecycleradapter.LuaCustRecyclerHolder"
local DiskCacheStrategy = luajava.bindClass "com.bumptech.glide.load.engine.DiskCacheStrategy"
VOCALOID_table={}
local id_table={
  "2134872913";
  "2157894445";
  "2020725645";
  "459717345",
  "1317505406",
  "22677570",
  "514765051",
  "502455381",
  "1966112474",
  "1840474281",
  "432486474",
  "22677558",
  "406716121",
  "2153390036",
  "2043178301",
  "2639291583",
  "1859603835",
  "507795306",
  "2650843590",
  "2691663339",
  "2648491185";
  "26440351";
  "4888328";
  "34509838";
  "22779029";
  "1440693335";
  "2674765182";
  "502455397";
  "1906277944";
  "1920592565";
  "1294899572";
  "858524";
}
local itemdata={
}
-- 1. 初始化RecyclerView
VOCALOID_RecyclerView.setLayoutManager(LinearLayoutManager(activity))

-- 2. 数据缓存表（避免重复请求）
local cachedData = {} -- {id163 = {name="...", artist="...", pic="..."}}

-- 3. 记录当前滚动状态
local isScrolling = false
VOCALOID_RecyclerView.addOnScrollListener(RecyclerView.OnScrollListener{
  onScrollStateChanged = function(recyclerView, newState)
    isScrolling = newState ~= RecyclerView.SCROLL_STATE_IDLE
    -- 停止滚动时刷新可见项
    if not isScrolling then
      --adp4.notifyDataSetChanged()
    end
  end
})

-- 4. 适配器定义（关键优化点）
adp4 = LuaCustRecyclerAdapter(AdapterCreator({
  getItemCount = function()
    return #id_table
  end,

  onCreateViewHolder = function(parent, viewType)
    local views = {} -- 控件集合
    local holder = LuaCustRecyclerHolder(loadlayout("res.layout.item_VOCAlOID", views))
    holder.view.setTag(views)

    -- 点击事件
    views.v_card.onClick = function()
      -- 点击逻辑（示例）
      print("Clicked item: "..holder.getAdapterPosition())
    end

    return holder
  end,

  onBindViewHolder = function(holder, position)
    local view = holder.view.getTag()
    local index = position + 1
    local id163 = id_table[index]

    -- 如果正在滚动，只显示占位
    if isScrolling then
      view.v_music.setText("加载中...")
      view.v_artist.setText("")
      Glide.with(activity).clear(view.cover) -- 清除图片
      return
    end

    -- 优先使用缓存数据
    if cachedData[id163] then
      view.v_music.setText(cachedData[id163].name)
      view.v_artist.setText(cachedData[id163].artist)
      Glide.with(activity)
      .load(cachedData[id163].pic)
      .placeholder(android.R.drawable.ic_menu_gallery) -- 默认占位图
      .into(view.cover)
      return
    end

    -- 无缓存时发起网络请求
    Http.get("https://y.music.163.com/m/song?id="..id163, function(code, content)
      if code == 200 then
        local name, artist = string.match(content, '<meta property="og:title" content="(.-) %- (.-) %- .- %- 网易云音乐" />')
        local pic = string.match(content, '<meta property="og:image" content="(.-)" />')

        -- 缓存数据
        cachedData[id163] = {
          name = name,
          artist = artist,
          pic = pic
        }

        -- 确保视图未被复用
        if holder.getAdapterPosition() == position then
          view.v_music.setText(name)
          view.v_artist.setText(artist)
          Glide.with(activity)
          .load(pic)
          .skipMemoryCache(false) -- 启用内存缓存
          .diskCacheStrategy(DiskCacheStrategy.ALL) -- 启用磁盘缓存
          .into(view.cover)
        end
       else
        view.v_music.setText("加载失败")
      end
    end)
  end,

  -- 5. 视图被复用时取消旧请求（需自行实现Http.cancel）
  onViewRecycled = function(holder)
    local view = holder.view.getTag()
    Glide.with(activity).clear(view.cover) -- 取消图片加载
    -- 此处可添加Http.cancel逻辑（如果有）
    
  end
}))

-- 6. 设置适配器
VOCALOID_RecyclerView.setAdapter(adp4)