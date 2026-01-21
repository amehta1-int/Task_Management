module Tasks
    class Create
      def initialize(user:, params:)
        @user = user
        @params = params
      end
  
      def call
        @user.tasks.create(@params)
      end
    end
  end

#Accepts user inputs and injects the parameters