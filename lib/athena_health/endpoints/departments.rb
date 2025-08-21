module AthenaHealth
  module Endpoints
    module Departments
      def all_departments(practice_id:, params: {})

        # This is going to hold all of the departments we get in batches.
        departments = []

        # We're going to be batching, so these will keep track of our progress.
        more = true
        offset = 0
        page_size = 1500 # The default page size is 1500, we don't handle custom page sizes.

        while more do

          # response has the following structure:
          # {
          #   "departments": [...],
          #   "totalcount": 10000,
          #   "next": "/v1/{practice_id}/departments?offset=1500"
          # }
          response = @api.call(
            endpoint: "#{practice_id}/departments",
            method: :get,
            params: params.merge({offset:})
          )

          departments = departments.concat(response["departments"])

          offset += page_size
          if offset > response["totalcount"]
            more = false
          end
        end

        DepartmentCollection.new({departments:})
      end

      def find_department(practice_id:, department_id:, params: {})
        response = @api.call(
          endpoint: "#{practice_id}/departments/#{department_id}",
          method: :get,
          params: params
        )

        Department.new(response.first)
      end
    end
  end
end
