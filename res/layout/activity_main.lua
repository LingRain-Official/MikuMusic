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
      title ="MikuMusicX",
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
    FragmentContainerView,
    id ="FragmentContainers",
    layout_width ="fill",
    layout_behavior ="appbar_scrolling_view_behavior",
    layout_height ="fill",
  },
  {
    BottomNavigationView,
    layout_width =-1,
    layout_gravity ="bottom",
    id ="bottombar",
    LabelVisibilityMode =0,
  },
  {
    FloatingActionButton,
    layout_margin ="16dp",
    layout_marginBottom ="110dp",
    layout_gravity ="bottom|end",
    src ="res/drawable/music.png",
    id ="fab",
  },
}