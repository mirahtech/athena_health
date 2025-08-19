module AthenaHealth
  module Endpoints
    module Providers
      def all_providers(practice_id:, params: {})

        # This is going to hold all of the providers we get in batches.
        providers = []

        # We're going to be batching, so these will keep track of our progress.
        more = true
        offset = 0
        page_size = 1500 # The default page size is 1500, we don't handle custom page sizes.

        while more do

          # response has the following structure:
          # {
          #   "providers": [...],
          #   "totalcount": 12820,
          #   "next": "/v1/8042/providers?SHOWALLPROVIDERIDS=true&offset=1500"
          # }
          response = @api.call(
            endpoint: "#{practice_id}/providers",
            method: :get,
            params: params.merge({offset:})
          )

          providers = providers.concat(response["providers"])

          offset += page_size
          if offset > response["totalcount"]
            more = false
          end
        end

        ProviderCollection.new({providers:})
      end

      def find_provider(practice_id:, provider_id:, params: {})
        response = @api.call(
          endpoint: "#{practice_id}/providers/#{provider_id}",
          method: :get,
          params: params
        )

        Provider.new(response.first)
      end
    end
  end
end
