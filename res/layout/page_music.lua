require "env"
local ColorStateList = luajava.bindClass "android.content.res.ColorStateList"
local Color = luajava.bindClass "android.graphics.Color"
import "me.wcy.lrcview.*"
local FileDrawable = require "mods.utils.FileDrawable"
local IconDrawable = require "mods.utils.IconDrawable"
return{
  LinearLayoutCompat;
  layout_width="fill",
  layout_height="fill";
  {
    ViewPager;
    layout_width="fill",
    layout_height="fill",
    id="MusicLayout";
    pages={
      {
        LinearLayoutCompat;
        layout_height="match_parent";
        layout_width="match_parent";
        orientation="vertical";
        gravity="center";
        {
          LinearLayoutCompat;
          layout_width="70%w";
          {
            MaterialButton;
            id = "fold";
            style = material.attr.materialIconButtonStyle ,
            IconTint = ( ColorStateList.valueOf (Colors.colorOnBackground) ),
            Icon = IconDrawable(activity.getLuaDir().."/res/drawable/fold.png"),
            onClick = function ( )
            end
          } ;
          {
            LinearLayoutCompat;
            layout_weight=1;
          };
          {
            MaterialButton;
            id="more";
            style = material.attr.materialIconButtonStyle ,
            IconTint = ( ColorStateList.valueOf (Colors.colorOnBackground) ),
            Icon = IconDrawable(activity.getLuaDir().."/res/drawable/more.png"),
            onClick = function ( )
            end
          } ;
        };
        {
          MaterialCardView;
          layout_height="65%w";
          layout_width="65%w";
          StrokeColor=0,
          id="card";
          {
            LinearLayoutCompat,
            layout_width=-1,
            layout_height=-1,
            {
              AppCompatImageView;
              layout_width="match_parent";
              layout_height="match_parent";
              id="img3";
            };
          };
        },
        {
          LinearLayoutCompat;
          layout_height="wrap_content";
          layout_width="match_parent";
          layout_gravity="center";
          layout_marginTop="2%h";
          gravity="center";
          {
            AppCompatImageView;
            id="musiclistButton";
            layout_width="4%h";
            layout_height="4%h";
            src="res/drawable/musiclist.png";
            ColorFilter=Colors.colorPrimary;
          };
          {
            AppCompatImageView;
            layout_marginRight="9%h";
            layout_width="4%h";
            layout_marginLeft="9%h";
            src="res/drawable/download.png";
            id="downloadButton";
            layout_height="4%h";
            ColorFilter=Colors.colorPrimary;
          };
          {
            AppCompatImageView;
            id="shareButton";
            layout_width="4%h";
            layout_height="4%h";
            src="res/drawable/fenxiang.png";
            ColorFilter=Colors.colorPrimary;
          };
        };
        {
          Slider;
          id="MusicSlider";
          layout_width="75%w";
          layout_marginTop="25dp";
        };
        {
          LinearLayoutCompat;
          layout_height="wrap_content";
          gravity="center";
          layout_width="65%w";
          {
            LinearLayoutCompat;
            layout_weight="1";
            layout_width="wrap_content";
            {
              MaterialTextView;
              id="currenttime";
              text="Start_time";
            };
          };
          {
            LinearLayoutCompat;
            layout_weight="1";
          };
          {
            MaterialTextView;
            id="endtime";
            layout_gravity="right";
            text="End_time";
          };
        };
        {
          LinearLayoutCompat;
          layout_width=-1;
          gravity="center";
          orientation=2;
          {
            AppCompatImageView;
            id="lastButton";
            src="res/drawable/last1.png";
            ColorFilter=Colors.colorPrimary;
            layout_height="40dp";
            layout_width="40dp";
          };
          {
            AppCompatImageView;
            id="playbtn";
            layout_marginLeft="30dp";
            layout_marginRight="30dp";
            src="res/drawable/bofang.png";
            ColorFilter=Colors.colorPrimary;
            layout_height="40dp";
            layout_width="40dp";
          };
          {
            AppCompatImageView;
            id="nextButton";
            src="res/drawable/next1.png";
            ColorFilter=Colors.colorPrimary;
            layout_height="40dp";
            layout_width="40dp";
          };
        };
      };
      {
        LinearLayoutCompat;

        gravity="center";
        layout_width="fill";
        layout_height="fill";
        orientation="vertical";
        {
          LrcView;
          id="lrcview";-- 歌词控件ID
          layout_width="fill";-- 歌词控件宽度
          layout_weight="1";
          -- layout_height="wrap_content";-- 歌词控件高度
          --[[ currentColor="#FFFFFF";-- 设置当前歌词颜色
    normalColor="#7FFFFFFF";-- 设置其他歌词颜色
    timeTextColor="#7FFFFFFF";-- 设置时间文本颜色
    dividerHeight="18dp";-- 设置歌词之间间距
    label="暂无歌词";-- 设置无歌词时显示
    normalTextSize="16sp";-- 设置其它歌词大小
    currentTextSize="18sp";-- 设置当前歌词大小
    lrcPadding="50dp";-- 设置歌词两侧距离
    timelineColor="#66FFFFFF";-- 设置选择线颜色
    timelineTextColor="#F0FFFFFF";-- 设置选中歌词颜色]]
        };
      };
    };
  };
}