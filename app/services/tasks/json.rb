module Tasks
    class Json
      FIELDS = %i[id title status priority due_date created_at updated_at].freeze
  
      def self.one(task)
        task.as_json(only: FIELDS)
      end
  
      def self.many(tasks)
        tasks.as_json(only: FIELDS)
      end
    end
  end