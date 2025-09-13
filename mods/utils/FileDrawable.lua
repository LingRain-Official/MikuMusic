local apply=luajava.bindClass
local BitmapDrawable = apply "android.graphics.drawable.BitmapDrawable"
local BitmapFactory = apply "android.graphics.BitmapFactory"
local FileInputStream = apply "java.io.FileInputStream"
return function(file)
  local fis = FileInputStream(activity.getLuaDir().."/"..file)
  local bitmap = BitmapFactory.decodeStream(fis)
  return BitmapDrawable(activity.getResources(), bitmap)
end