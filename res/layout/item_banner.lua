require "env"

return{
  LinearLayoutCompat;
  layout_width="fill";
  layout_height="fill";
  {
    MaterialCardView,
    id="card",
    layout_width="match_parent";
    layout_height="match_parent";
    cardElevation="0";
    radius="15dp";
    StrokeColor=0;
    {
      AppCompatImageView;
      layout_width="match_parent";
      layout_height="match_parent";
      scaleType = "center";
      id="img";
    };

  };
};