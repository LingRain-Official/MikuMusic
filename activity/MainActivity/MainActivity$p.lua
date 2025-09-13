require "env"
local LuaCustRecyclerAdapter = luajava.bindClass "com.lua.custrecycleradapter.LuaCustRecyclerAdapter"
local LinearLayoutManager = luajava.bindClass "androidx.recyclerview.widget.LinearLayoutManager"
local LuaCustRecyclerHolder = luajava.bindClass "com.lua.custrecycleradapter.LuaCustRecyclerHolder"
local AdapterCreator = luajava.bindClass "com.lua.custrecycleradapter.AdapterCreator"
local PopupMenu = luajava.bindClass "androidx.appcompat.widget.PopupMenu"
local NotificationUtil = require "mods.utils.NotificationUtil"
local MusicData = require "mods.utils.MusicData"
local pMusic = require "mods.utils.pMusicModule"
local Music = require "mods.utils.MusicModule"
local http = require "http"
local Glide = luajava.bindClass "com.bumptech.glide.Glide"
local p = {
  {
    "DECO*27",
    {
      "432486474",
      "2639291583",
      "2719630556",
      "2672829798",
      "1840474281",
      "28364361",
      "27853410",
      "2008003632",
      "502455382",
      "2158993579",
    };
  };
  {
    "sasakure.UK";
    {
      "1855089388";
      "26440351";
      "37820478";
      "22813141";
      "1461398728";
      "26440346";
    };
  };
  {
    "Iyowa(胃弱)";
    {
      "1825056882";
      "1991191322";
      "1875436617";
      "1855988913";
      "2114108283";
    };
  };
  {
    "wowaka";
    {
      "502455381";
      "22699098";
      "22677436";
      "4888353";
      "22699089";
    };
  };
  {
    "椎名もた";
    {
      "33516239";
      "27853206";
      "1379410951";
      "33516237";
    };
  };
  {
    "ピノキオピー";
    {
      "1849309117";
      "1825037926";
      "1951285318";
      "1859603835";
      "2674765182";
      "1878313261";
      "2716424334";
      "1385316774";
    };
  };
  {
    "网络(不分p主)";
    {
      "2132901814";
      "2074759832";
      "2700788167";
      "2153390036";
      "469073360";
      "507795306";
      "1966112474";
      "2134872913";
      "2084302199";
      "1456486939";
      "1492827692";
      "2051317320";
      "1826139261";
      "28953243";
      "32431066";
    }
  }
}

pMusicList={}
p_list = p[1][2]
artist_p.setText(p[1][1])
numofartist.setText("共" .. tostring(#p[1][2]) .. "首歌")
local function updataRecyclerView()
  local adp_p = LuaCustRecyclerAdapter(AdapterCreator({
    getItemCount = function()
      return #p_list
    end,
    onCreateViewHolder = function(parent, viewType)
      local views = {}
      local holder = LuaCustRecyclerHolder(loadlayout("res.layout.item_VOCALOID", views))
      holder.view.setTag(views)
      views.musicCard.onClick = function()
        local position = holder.getAdapterPosition()
        local index = position + 1
        --更新音乐数据
        isLocalMusic = false
        isPMusic = true
        isUserAdd = false
        sequence = index
        id = p_list[sequence]
        print(id)
        --MusicSlider.setValue(0)
        pMusic.MusicPlay(MusicData.getMusicRes(id))
        Music.loadLyric(id)
        Music.loadCover(id, img3)
        NotificationUtil.updatePlaybackState()
        NotificationUtil.updateNotification()
      end
      return holder
    end,

    onBindViewHolder = function(holder, position)
      local view = holder.view.getTag()
      local index = position + 1
      Http.get("https://y.music.163.com/m/song?id=" .. p_list[index], function(code, content)
        if code == 200 then
          local name, artist = string.match(content, '<meta property="og:title" content="(.-) %- (.-) %- .- %- 网易云音乐" />')
          local pic1 = string.match(content, '<meta property="og:image" content="(.-)" />')
          Glide.with(activity.getApplicationContext()).load(pic1).into(view.p_cover)
          view.p_music.setText(name)
          view.p_artist.setText(artist)
         else
          view.p_cover.setVisibility(View.GONE)
        end
      end)
    end,
  }))

  pRecyclerView.setAdapter(adp_p).setLayoutManager(LinearLayoutManager(activity))
end

updataRecyclerView()

changeArtist.onClick=function(v)
  local pop = PopupMenu(this, v)
  local menu = pop.Menu


  -- 添加分享菜单项
  menu.add("DECO*27").onMenuItemClick = function(value)
    p_list = p[1][2]
    artist_p.setText(p[1][1])
    numofartist.setText("共" .. tostring(#p[1][2]) .. "首歌")
    updataRecyclerView()
  end
  menu.add("sasakure.UK").onMenuItemClick = function(value)
    p_list = p[2][2]
    artist_p.setText(p[2][1])
    numofartist.setText("共" .. tostring(#p[2][2]) .. "首歌")
    updataRecyclerView()
  end
  menu.add("Iyowa(胃弱)").onMenuItemClick = function(value)
    p_list = p[3][2]
    artist_p.setText(p[3][1])
    numofartist.setText("共" .. tostring(#p[3][2]) .. "首歌")
    updataRecyclerView()
  end
  menu.add("wowaka").onMenuItemClick = function(value)
    p_list = p[4][2]
    artist_p.setText(p[4][1])
    numofartist.setText("共" .. tostring(#p[4][2]) .. "首歌")
    updataRecyclerView()
  end
  menu.add("椎名もた").onMenuItemClick = function(value)
    p_list = p[5][2]
    artist_p.setText(p[5][1])
    numofartist.setText("共" .. tostring(#p[5][2]) .. "首歌")
    updataRecyclerView()
  end
  menu.add("ピノキオピー").onMenuItemClick = function(value)
    p_list = p[6][2]
    artist_p.setText(p[6][1])
    numofartist.setText("共" .. tostring(#p[6][2]) .. "首歌")
    updataRecyclerView()
  end
menu.add("网络(不分p主)").onMenuItemClick = function(value)
    p_list = p[7][2]
    artist_p.setText(p[7][1])
    numofartist.setText("共" .. tostring(#p[7][2]) .. "首歌")
    updataRecyclerView()
  end  
  pop.show()
end