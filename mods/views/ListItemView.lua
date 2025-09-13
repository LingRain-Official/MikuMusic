local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local AppCompatImageView = bindClass "androidx.appcompat.widget.AppCompatImageView"
local AppCompatTextView = bindClass "androidx.appcompat.widget.AppCompatTextView"
local MaterialCardView = bindClass "com.google.android.material.card.MaterialCardView"
local Class = require "modules.class"
local Glide = luajava.bindClass "com.bumptech.glide.Glide"
return Class {

  extends = LinearLayoutCompat,

  constructor = function()
    return Layout.inflate("res.layout.listitemview_layout", LinearLayoutCompat)
  end,

  methods = {

    function setText(self,text,text2)
      
      self.getChildAt(1).getChildAt(0).setText(text:match("^(.-),"))
      self.getChildAt(1).getChildAt(1).setText(text:match(",(.+)"))
    end,

    function setIcon(self, src)
      
       Glide.with(activity.getApplicationContext()).load(src).into(self.getChildAt(0))
      --self.getChildAt(2).getChildAt(0).setText(src)
    end,

  }

}