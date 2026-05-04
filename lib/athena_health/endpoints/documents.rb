module AthenaHealth
  module Endpoints
    module Documents
      def all_document_types(practice_id:, search_value:, params: {})

        # This is going to hold all of the document types we get in batches.
        document_types = []

        # We're going to be batching, so these will keep track of our progress.
        more = true
        offset = 0
        page_size = 500 # This endpoint allows up to 500 per page (default 100, max 500).

        # Athena requires `searchvalue` on this endpoint; merge it into params so
        # callers can still pass other optional filters (e.g. documentsubclass).
        base_params = params.merge(searchvalue: search_value, limit: page_size)

        while more do

          # response has the following structure:
          # {
          #   "documenttypes": [...],
          #   "totalcount": 1234,
          #   "next": "/v1/{practice_id}/documenttypes?offset=500&limit=500"
          # }
          # Skip offset on the first call so the URL stays simple (Athena treats
          # a missing offset as 0).
          page_params = offset.zero? ? base_params : base_params.merge({ offset: })
          response = @api.call(
            endpoint: "#{practice_id}/documenttypes",
            method: :get,
            params: page_params
          )

          document_types = document_types.concat(response["documenttypes"] || [])

          offset += page_size
          if offset >= response["totalcount"]
            more = false
          end
        end

        DocumentTypeCollection.new({ documenttypes: document_types })
      end
    end
  end
end
