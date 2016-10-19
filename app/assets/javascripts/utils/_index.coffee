# 灵活自定义 className
window.ClassName = require 'utils/ClassName'

# 随机字符串
window.randstr = require 'utils/randstr'

# http://fontawesome.io/icons/
window.FaIcon = require 'utils/FaIcon'

# 日期格式化函数
format_date = require 'utils/format_date'
Date.prototype.format = (str)-> format_date(this, str)

# 颜色序列函数
window.color20 = require 'utils/color20'

# 修正 android chrome 浏览器没有 Object.assign 方法的 bug
require 'utils/object_assign'