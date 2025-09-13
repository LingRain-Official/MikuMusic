require "env"
return{
  LinearLayoutCompat;
  layout_width = "fill";
  layout_height = "fill";
  orientation = "vertical";
  {
    ViewPager;
    layout_width = "fill";
    layout_height = "fill";
    pages = {
      LinearLayoutCompat;
      layout_width = "fill";
      layout_height = "fill";
      orientation = "vertical";
      gravity = "center";
    };
  };
};