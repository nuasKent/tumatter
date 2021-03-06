module Fog
  module Compute
    class Ovirt
      class V3
        class Real
          def destroy_interface(id, options)
            raise ArgumentError, "instance id is a required parameter" unless id
            raise ArgumentError, "interface id is a required parameter for destroy-interface" unless options.key? :id

            client.destroy_interface(id, options[:id])
          end
        end

        class Mock
          def destroy_interface(id, options)
            raise ArgumentError, "instance id is a required parameter" unless id
            raise ArgumentError, "interface id is a required parameter for destroy-interface" unless options.key? :id
            true
          end
        end
      end
    end
  end
end
