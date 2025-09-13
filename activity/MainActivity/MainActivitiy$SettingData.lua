local function recreate()
  task(300, function()
    this.recreate()
  end)
end
local json = require "json"
local MaterialAlertDialogBuilder = luajava.bindClass "com.google.android.material.dialog.MaterialAlertDialogBuilder"
local SettingLayUtil = require "mods.utils.SettingLayUtil"
local MyPopupMenu = require "mods.utils.MyPopupMenu"
return{
  {
    SettingLayUtil.TITLE,
    title="界面",
  },
  {
    SettingLayUtil.ITEM_SWITCH,
    title="动态取色",
    message="仅支持安卓十二及以上",
    icon=activity.getLuaDir().."/res/drawable/color.png",
    checked = this.getSharedData("setting_DynamicColors"),
    event = function(_, checked)
      this.setSharedData("setting_DynamicColors", checked)
      --activity.setSharedData("mainRecreate", true)
      recreate()
    end
  },
  {
    SettingLayUtil.ITEM_NOMESSAGE,
    title="主题",
    icon=activity.getLuaDir().."/res/drawable/UI.png",
    onClick=function(v)
      MyPopupMenu({
        [1] = {
          "MaterialYou", function()
            this.setSharedData("setting_theme","my")
          end
        },
        [2] = {
          "MaterialComponents", function()
            this.setSharedData("setting_theme","mc")
          end
        },
      }, v, {dp2px(55), 0}, "主题")
    end
  },
  {
    SettingLayUtil.TITLE,
    title="管理",
  },
  {
    SettingLayUtil.ITEM,
    title="清除缓存",
    message="清除应用私有目录内缓存的所有音乐文件";
    icon=activity.getLuaDir().."/res/drawable/delete.png",
    onClick=function(v)
      os.execute("rm -r "..activity.getLuaDir().."/local")
      MaterialToast("清除完成")
    end
  },
  {
    SettingLayUtil.ITEM_NOMESSAGE,
    title="播放设置",
    icon=activity.getLuaDir().."/res/drawable/musiclist.png",
    onClick=function(v)
      activity.newActivity("activity/MusicSettingActivity/MusicSettingActivity")
    end
  },
  {
    SettingLayUtil.TITLE,
    title="其他",
  },
  {
    SettingLayUtil.ITEM,
    title="检查更新",
    message="当前版本: "..activity.getPackageManager().getPackageInfo(activity.getPackageName(), 0).versionName,
    icon=activity.getLuaDir().."/res/drawable/updata.png",
    onClick=function(v)
      Http.get("http://lingrain.online/updata.json", function(code, content)
        if code == 200 then
          local table = json.decode(content)
          local nowversion = 140
          local newversion = table.versionCode
          if newversion > nowversion then
            MaterialAlertDialogBuilder(this)
            .setTitle("发现新版本")
            .setMessage(table.new)
            .setPositiveButton("确认",{onClick=function(v)end})
            .show()
           else
            Toast.maker("当前已是最新版本")
          end
         else
          MaterialToast("无网络连接，http error code"..code)
        end
      end)
    end
  },
  {
    SettingLayUtil.ITEM_NOMESSAGE,
    title="用户协议",
    icon=activity.getLuaDir().."/res/drawable/user.png",
    onClick=function(v)
      MaterialAlertDialogBuilder(this)
      .setTitle("LingRain用户协议")
      .setMessage([==[感谢您使用由 LingRain Studio 开发的软件和服务。为了确保您在使用我们的软件和服务时获得最佳体验，并保护您的合法权益，请仔细阅读以下用户协议（以下简称“协议”）。本协议适用于 LingRain Studio 开发的所有软件。

1. 接受协议
1.1 您下载、安装、使用或以其他方式访问 LingRain Studio 开发的任何软件，即表示您已阅读、理解并同意接受本协议的所有条款和条件。

1.2 如果您不同意本协议的任何条款，请立即停止使用我们的软件和服务。

2. 软件使用许可
2.1 LingRain Studio 授予您一项非独占、不可转让的个人许可，允许您根据本协议的条款使用我们的软件。

2.2 除通过官方公开链接获取源代码外，您不得对软件进行反向工程、反编译、拆解、尝试导出源代码或以其他方式尝试获取软件的源代码。

3. 用户行为
3.1 您同意在使用我们的软件和服务时遵守所有适用的法律法规。

3.2 您不得使用我们的软件和服务进行任何非法活动，包括但不限于侵犯他人知识产权、传播恶意软件或进行网络攻击。

3.3 您不得通过我们的软件和服务传播任何违法、淫秽、诽谤、侮辱、威胁、骚扰或令人反感的内容。

3.4 您不得尝试干扰或破坏我们软件和服务的正常运行，包括但不限于使用恶意软件、病毒或进行拒绝服务攻击。

4. 知识产权
4.1 LingRain Studio 保留对软件及其所有相关内容的全部权利，包括但不限于文本、图形、用户界面、视觉界面、商标、标志、声音、音乐、算法和代码。

4.2 您承认并同意，所有与软件相关的知识产权均归 LingRain Studio 或其许可人所有。

4.3 本协议不授予您任何有关软件知识产权的权利，除非本协议中明确规定的除外。

5. 隐私政策
5.1 LingRainStudio 尊重您的隐私，并承诺保护您的个人信息。请参阅我们的隐私政策，了解我们如何收集、使用、披露和保护您的个人信息。

5.2 您同意我们根据隐私政策的规定收集、使用和披露您的个人信息。

6. 免责声明
6.1 LingRain Studio 提供的软件和服务按“原样”和“可用性”提供，不附带任何形式的明示或暗示的保证，包括但不限于对适销性、特定用途适用性和非侵权的保证。

6.2 LingRain Studio 不保证软件和服务将始终不中断、安全、无错误或无病毒

]==])
      .show()
    end
  },
}