# utils
require 'utils/index'

# # layouts
require 'layouts/index'

# # app components
window.AppComponents = {}
window.register = (component, name=null)->
  component_name = name || component.displayName
  window.AppComponents[component_name] = component

# auth
window.register (require 'app/auth/AuthSignInPage'), 'AuthSignInPage'

# organization
window.register require 'app/OrganizationsTreesPage'
window.register require 'app/OrganizationTreePage'
window.register require 'app/OrganizationNodeShow'

# chatroom
window.register require 'app/chat/ChatCharAvatar'
window.register require 'app/chat/ChatPageOrganizationTree'
window.register require 'app/chat/ChatPageChatRoom'
window.register require 'app/chat/ChatPageCurrentUser'
window.register require 'app/chat/ChatPage'