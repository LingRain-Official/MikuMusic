require "env"
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
      RecyclerView;
      layout_width="fill";
      layout_height="fill";
      
    };
  };
};