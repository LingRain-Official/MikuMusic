require "env"
return
{
  CoordinatorLayout,
  layout_width =-1,
  layout_height =-1,
  id ="background",
  {
    AppBarLayout,
    backgroundColor =0,
    layout_width =-1,
    id ="appBar",
    fitsSystemWindows=true,
    {
      CollapsingToolbarLayout,
      layout_width =-1,
      layout_height ="120dp",
      layout_scrollFlags =3,
      contentScrim=ColorDrawable(CollapsingToolbarLayoutColor),
      title ="关于应用",
      id ="collapsingtoolbarlayout";
      {
        MaterialToolbar,
        id ="toolbar",
        layout_width =-1,
        layout_height ="56dp",
        layout_collapseMode ="pin",
      },
    },
  },
  {
    NestedScrollView,
    layout_width="fill",
    layout_height="fill",
    layout_behavior="appbar_scrolling_view_behavior",
    fillViewport="true",
    {
      LinearLayoutCompat,
      orientation="vertical",
      layout_width="fill",
      layout_height="fill",

      {
        MaterialCardView,
        layout_width="fill",
        layout_margin="20dp",
        clickable=true,
        StrokeColor=Colors.colorPrimaryContainer,
        CardBackgroundColor=0,
        {
          LinearLayoutCompat,
          orientation="vertical",
          gravity="center",
          layout_width="fill",
          layout_height="fill",
          {
            AppCompatImageView,
            layout_height="80dp",
            layout_width="80dp",
            src="icon.png",
            padding="8dp",
            layout_margin="15dp",
            layout_marginBottom="0dp",
          },
          {
            AppCompatTextView,
            gravity="center",
            text="MikuMusic";
            layout_margin="8dp",
            layout_marginBottom="0dp",
            textColor=colorOnBackground,
          },
          {
            AppCompatTextView,
            text="虛擬的歌姬，真實的情感";
            gravity="center",
            layout_marginTop="8dp",
            layout_margin="15dp",
            textColor=Colors.colorOutline,
          },
        },
      },
      {
        RecyclerView,
        layout_width="fill",
        id="recyclerView",
      },
    },
  },
}