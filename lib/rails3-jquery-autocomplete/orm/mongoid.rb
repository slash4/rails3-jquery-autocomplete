module Rails3JQueryAutocomplete
  module Orm
    module Mongoid
      def get_autocomplete_order(method, options, model=nil)
        order = options[:order]
        if order
          order.split(',').collect do |fields|
            sfields = fields.split
            [sfields[0].downcase.to_sym, sfields[1].downcase.to_sym]
          end
        else
          [[method.first.to_sym, :asc]]
        end
      end

      def get_autocomplete_items(parameters)
        model          = parameters[:model]
        method         = Array(parameters[:method])
        options        = parameters[:options]
        is_full_search = options[:full]
        term           = parameters[:term]
        limit          = get_autocomplete_limit(options)
        order          = get_autocomplete_order(method, options)

        if is_full_search
          search = '.*' + term + '.*'
        else
          search = '^' + term
        end
        or_array = Array.new
        for key in method
          met = Hash.new
          met[key.to_sym] = /#{search}/i
          or_array << met
        end
        items  = model.any_of(or_array).limit(limit).order_by(order)
      end
    end
  end
end
