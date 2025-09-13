require "env"
local ListItemView = require "mods.views.ListItemView"
local IconDrawable = require "mods.utils.IconDrawable"
local FileDrawable = require "mods.utils.FileDrawable"
local Banner = activity.loadDex(activity.getLuaPath("libs/Pager2Banner.dex")).loadClass("com.to.aboomy.pager2banner.Banner")
local ColorStateList = luajava.bindClass "android.content.res.ColorStateList"
return
{
  NestedScrollView,
  layout_width=-1,
  layout_height=-1,
  fillViewport=true,
  --layout_behavior="appbar_scrolling_view_behavior",
  {
    LinearLayoutCompat,
    layout_width=-1,
    layout_height=-1,
    orientation=1,
    {
      Banner,
      id="banner",
      layout_width="fill",
      layout_height="190dp",
    },
    {
      MaterialCardView;
      layout_width="fill";
      layout_marginTop="10dp";
      layout_marginLeft="10dp";
      layout_marginRight="10dp";
      StrokeColor=Colors.colorPrimaryContainer,
      {
        LinearLayoutCompat;
        layout_width="fill";
        layout_height="fill";
        orientation=1,
        {
          MaterialTextView;
          textColor=Colors.colorOnBackground;
          text="无题";
          id="title";
          textSize="20sp";
          layout_marginRight="15dp";
          layout_marginLeft="15dp";
          layout_marginTop="15dp";
        };
        {
          MaterialTextView;
          id="content2";
          textColor=Colors.colorOnBackground;
          text="在漸漸沉淪的世界中 遇見你";
          layout_marginLeft="15dp";
          layout_marginBottom="10dp";
          layout_marginRight="15dp";
        };
      };
    };
    {
      MaterialCardView;
      layout_width="fill";
      layout_marginTop="10dp";
      layout_marginLeft="10dp";
      layout_marginRight="10dp";
      StrokeColor=Colors.colorPrimaryContainer,
    };
    {
      View;
      layout_height="95dp";
      layout_width="fill"
    };
  };
};