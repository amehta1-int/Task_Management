Rails.application.config.session_store :cookie_store,  #cookie based session storage
  key: "_task_manager_session",    #name of the cookie
  expire_after: 30.minutes,    #session expires after 30 minutes
  secure: Rails.env.production?,    #Only accepts HTTPS in production environment
  httponly: true,    #Accepts only HTTP, so javascript can't read this
  same_site: :lax    #Accepts communication only with the same site to prevent csrf attacks
