require "env"
return
{
  NestedScrollView,
  layout_width = - 1,
  layout_height = - 1,
  fillViewport = true,
  --layout_behavior="appbar_scrolling_view_behavior",
  {
    LinearLayoutCompat,
    layout_width = - 1,
    layout_height = - 1,
    orientation = 1,
    {
      TabLayout,
      layout_width = 'fill';
      layout_height = '48dp';
      id = 'tab';
    },
    {
      ViewPager,
      layout_width = 'fill';
      layout_height = 'fill';
      layout_weight = '1';
      id = 'pagev';
      pages = {
        {
          LinearLayoutCompat,
          layout_width = - 1,
          layout_height = - 1,
          orientation = 1,
          {
            RecyclerView;
            layout_width = "fill";
            layout_height = "fill";
            id = "musicListRecyclerView";
          };
        };
        {
          LinearLayoutCompat,
          layout_width = - 1,
          layout_height = - 1,
          orientation = 1,
          {
            RecyclerView;
            layout_width = "fill";
            layout_height = "fill";
            id = "localMusicRecyclerView";
          };
        };
        {
          LinearLayoutCompat,
          layout_width = "fill",
          layout_height = "fill",
          orientation = 1,
          {
            MaterialCardView;
            layout_width="fill";
            StrokeColor=Colors.colorOnBackground,
            layout_margin="10dp";
            id="changeArtist";
            {
              LinearLayoutCompat;
              padding = "15dp";
              orientation = 1,
              layout_width = "match_parent";
              {
                MaterialTextView;
                textSize = "20sp";
                text = "artist";
                id="artist_p";
              };
              {
                MaterialTextView;
                text = "共#首歌";
                id="numofartist";
              };
            };
          };
          {
            RecyclerView;
            layout_width = "fill";
            layout_height = "fill";
            id = "pRecyclerView";
          };
        };
      };
    };
    {
      View;
      layout_height = "80dp";
      layout_width = "fill"
    };
  };
};