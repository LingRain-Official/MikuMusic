require "env"
local LinearLayoutManager = luajava.bindClass "androidx.recyclerview.widget.LinearLayoutManager"
local SettingLayUtil = require "mods.utils.SettingLayUtil"

activity

.setContentView("res.layout.activity_about")

.setSupportActionBar(toolbar)

.getSupportActionBar()

.setDisplayHomeAsUpEnabled(true)

local data2 = {
  {
    SettingLayUtil.TITLE,
    title="应用信息",
  },
  {
    SettingLayUtil.ITEM,
    title="应用版本",
    message=activity.getPackageManager().getPackageInfo(activity.getPackageName(), 0).versionName;
    icon=activity.getLuaDir().."/res/drawable/about.png",
    onClick=function(v)
    end
  },
  {
    SettingLayUtil.TITLE,
    title="贡献名单",
  },
  {
    SettingLayUtil.RADIUSITEM,
    title="cmouren191",
    message="主程序编写";
    icon="http://q1.qlogo.cn/g?b=qq&nk=1422561304&s=100",
    onClick=function(v)
    end
  },
  {
    SettingLayUtil.RADIUSITEM,
    title="Xiayu",
    message="大牛";
    icon="http://q1.qlogo.cn/g?b=qq&nk=928182278&s=100",
    onClick=function(v)
    end
  },
  {
    SettingLayUtil.RADIUSITEM,
    title="Pafonshaw_⁧⁧满穗_⁧ ",
    message="来自MikuBeat的音乐解析思路";
    icon="http://q1.qlogo.cn/g?b=qq&nk=271607916&s=100",
    onClick=function(v)
    end
  },
  {
    SettingLayUtil.RADIUSITEM,
    title="平方厘米cm² ",
    message="图标绘制";
    icon="http://q1.qlogo.cn/g?b=qq&nk=184162815&s=100",
    onClick=function(v)
    end
  },
  {
    SettingLayUtil.RADIUSITEM,
    title="伟大的你 ",
    message="感谢支持";
    icon="http://q1.qlogo.cn/g?b=qq&nk=1900381294&s=100",
    onClick=function(v)
    end
  },
  {
    SettingLayUtil.TITLE,
    title="其他",
  },
  {
    SettingLayUtil.ITEM_NOMESSAGE,
    title="GitHub",
    icon=activity.getLuaDir().."/res/drawable/github.png",
    onClick=function(v)
    end
  },
  {
    SettingLayUtil.ITEM,
    title="音源",
    message="music163",
    icon=activity.getLuaDir().."/res/drawable/music.png",
    onClick=function(v)
    end
  },
}
local Recadapter = SettingLayUtil.newAdapter(data2)
recyclerView
.setAdapter(Recadapter)
.setLayoutManager(LinearLayoutManager(this))
.setHasFixedSize(true)