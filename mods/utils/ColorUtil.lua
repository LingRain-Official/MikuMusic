require "import"
import "com.google.android.material.color.DynamicColors"

local LuaThemeUtil = luajava.bindClass "github.daisukiKaffuChino.utils.LuaThemeUtil"
luaTheme = LuaThemeUtil(this)
backgroundc=luaTheme.ColorBackground

-- 背景颜色：应用的主要背景色，通常用于窗口或页面的背景
colorBackground = luaTheme.colorBackground

-- 背景上的文字颜色：用于在 `colorBackground` 背景上的文字，确保文字在背景上清晰可见
colorOnBackground = luaTheme.colorOnBackground

-- 表面颜色：用于组件的表面，如卡片、弹出菜单等
colorSurface = luaTheme.colorSurface

-- 表面变体颜色：用于表面的变体，例如在表面上的不同状态或区域
colorSurfaceVariant = luaTheme.colorSurfaceVariant

-- 表面变体上的文字颜色：用于在 `colorSurfaceVariant` 背景上的文字
colorOnSurfaceVariant = luaTheme.colorOnSurfaceVariant

-- 主要颜色：应用的主要色调，通常用于主要按钮、应用栏等关键组件
colorPrimary = luaTheme.colorPrimary

-- 主要颜色上的文字颜色：用于在 `colorPrimary` 背景上的文字，确保文字在主要颜色上清晰可见
colorOnPrimary = luaTheme.colorOnPrimary

-- 主要容器颜色：用于主要容器组件的背景，如主要卡片、主要按钮等
colorPrimaryContainer = luaTheme.colorPrimaryContainer

-- 主要容器上的文字颜色：用于在 `colorPrimaryContainer` 背景上的文字
colorOnPrimaryContainer = luaTheme.colorOnPrimaryContainer

-- 次要颜色：应用的次要色调，用于次要按钮、标签等次要组件
colorSecondary = luaTheme.colorSecondary

-- 次要颜色上的文字颜色：用于在 `colorSecondary` 背景上的文字，确保文字在次要颜色上清晰可见
colorOnSecondary = luaTheme.colorOnSecondary

-- 次要容器颜色：用于次要容器组件的背景，如次要卡片、次要按钮等
colorSecondaryContainer = luaTheme.colorSecondaryContainer

-- 次要容器上的文字颜色：用于在 `colorSecondaryContainer` 背景上的文字
colorOnSecondaryContainer = luaTheme.colorOnSecondaryContainer

-- 轮廓颜色：用于组件的轮廓，如按钮边框、输入框边框等
colorOutline = luaTheme.colorOutline