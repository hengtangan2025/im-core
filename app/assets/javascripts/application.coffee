# utils
window.ClassName = require 'utils/ClassName'
window.randstr = require 'utils/randstr'

# http://fontawesome.io/icons/
window.FaIcon = require 'utils/FaIcon'

format_date = require 'utils/format_date'
Date.prototype.format = (str)-> format_date(this, str)

window.color20 = require 'utils/color20'

# # layouts
window.YieldComponent = require 'react/layouts/YieldComponent'
window.AppLayout = require 'react/layouts/AppLayout'

# components
window.OrganizationsTreesPage = require 'app/OrganizationsTreesPage'
window.OrganizationTreePage = require 'app/OrganizationTreePage'
window.OrganizationNodeShow = require 'app/OrganizationNodeShow'

window.ChatPageOrganizationTree = require 'app/chat/ChatPageOrganizationTree'
window.ChatPageChatRoom = require 'app/chat/ChatPageChatRoom'
window.ChatPageCurrentUser = require 'app/chat/ChatPageCurrentUser'
window.ChatPage = require 'app/chat/ChatPage'