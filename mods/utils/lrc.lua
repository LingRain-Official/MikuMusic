local json = require "json"
local _M = {}
function _M.setLyric(lrc,lrcen)
  lrcview.loadLrc(lrc,lrcen)
  --print(lrc)
  
  --lrcview.setPicture(activity.getLuaDir().."/res/drawable/bofang.png")

end

function _M.loadLyric(id163)
  Http.get("http://music.163.com/api/song/lyric?id="..id163.."&lv=4&kv=-1&tv=-1", function(code, content)
    if code == 200 then
      if pcall(function()
        end)
        local lrcbody=json.decode(content)
        local lrc=lrcbody.lrc.lyric
        if #lrc > 1 then
          --lrcview.setPicture(activity.getLuaDir().."/res/musiclist.png")
          if pcall(function()
              if lrcbody.tlyric.lyric then
                local lrcen=lrcbody.tlyric.lyric
                _M.setLyric(lrc,lrcen)
               else
                _M.setLyric(lrc,_)
              end
            end)
           else
            _M.setLyric(lrc,_)
          end
         elseif #lrc < 1 then
          Http.get("http://music.163.com/api/song/lyric?id="..id163.."&lv=1&kv=1&tv=-1", function(code, content)
            local lrcbody=json.decode(content)
            local lrc=lrcbody.tlyric.lyric
            local lrcen=lrcbody.lrc.lyric
            _M.setLyric(lrc,lrcen)
          end)
        end
       else
      end
    end
  end)
end
return _M