require "env"
local apply = luajava.bindClass
local AppCompatTextView = apply "androidx.appcompat.widget.AppCompatTextView"
local WindowManager = apply "android.view.WindowManager"
local ColorDrawable = apply "android.graphics.drawable.ColorDrawable"
local LinearLayoutCompat = apply "androidx.appcompat.widget.LinearLayoutCompat"
local MaterialCardView = apply "com.google.android.material.card.MaterialCardView"
local PopupWindow = apply "android.widget.PopupWindow"
local FrameLayout = apply "android.widget.FrameLayout"

return function(data, view, place, title)
  local layout = {
    FrameLayout,
    {
      MaterialCardView,
      strokeWidth=0,
      layout_width="200dp",
      {
        LinearLayoutCompat,
        layout_width=-1,
        id="list",
        orientation=1,
        {
          AppCompatTextView,
          id="title",
          textColor=Colors.colorPrimary,
          textSize="16sp",
          textStyle="bold",
          layout_margin="15dp",
          visibility=8,
        },
      },
    },
  }

  local item = {
    FrameLayout,
    padding="15dp",
    layout_width=-1,
    {
      AppCompatTextView,
      id="text",
    },
  }

  local views = {}

  local lp = activity.getWindow().getAttributes()
  lp.alpha = 0.85
  activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND)

  local pop = PopupWindow(activity)
  pop.setContentView(loadlayout(layout, views))
  pop.setFocusable(true)
  pop.setBackgroundDrawable(ColorDrawable(0x00000000))
  pop.onDismiss=function()
    lp.alpha = 1
    activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND)
  end

  if title
    views.title.setVisibility(0)
    views.title.setText(title)
  end

  for k,v in ipairs(data)
    local _views = {}
    local item = loadlayout(item, _views)
    item.setBackground(getRipple(false,RippleColor))
    item.onClick=function()
      v[2]()
      pop.dismiss()
    end
    _views.text.setText(v[1])
    views.list.addView(item)
  end

  pop.showAsDropDown(view, place[1], place[2])
end