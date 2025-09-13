local AppCompatTextView = luajava.bindClass "androidx.appcompat.widget.AppCompatTextView"
local MaterialCardView = luajava.bindClass "com.google.android.material.card.MaterialCardView"
local Gravity = luajava.bindClass "android.view.Gravity"
local Toast = luajava.bindClass "android.widget.Toast"
return function(content)
  local ToastLayout= {
    MaterialCardView;
    id="tc";
    padding="10dp";
    layout_height="wrap_content";
    layout_width="wrap_content";
    {
      AppCompatTextView;
      id="text";
      text=content;
      layout_margin="10dp";
    };
  };
  local toast=Toast.makeText(activity,content,Toast.LENGTH_SHORT).setView(loadlayout(ToastLayout))
  toast.setGravity(Gravity.BOTTOM,0,60)
  toast.show()
end