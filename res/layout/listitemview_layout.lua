require "env"
local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local AppCompatImageView = bindClass "androidx.appcompat.widget.AppCompatImageView"
local AppCompatTextView = bindClass "androidx.appcompat.widget.AppCompatTextView"

return
{
  LinearLayoutCompat;
  layout_width ="match_parent";
  paddingLeft ="20dp";
  padding ="10dp";
  orientation ="horizontal";
  layout_height ="wrap_content";
    {
      AppCompatImageView;
      layout_width ="35dp";
      layout_height ="35dp";
      layout_gravity = "center",
      ColorFilter=Colors.colorOnBackground;
    };
  {
    LinearLayoutCompat;
    layout_width ="match_parent";
    paddingLeft ="10dp";
    layout_gravity ="center";
    orientation =1,
    {
      AppCompatTextView;
      textSize ="16sp";
      text ="Title";
      textColor =Colors.colorOnBackground;
    };
    {
      AppCompatTextView;
      text ="Text";
      textSize ="12sp";
      textColor =Colors.colorOnBackground;
    };
  };
};