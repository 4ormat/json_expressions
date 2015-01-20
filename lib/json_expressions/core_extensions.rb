module JsonExpressions
  module Strict; end
  module Forgiving; end
  module Ordered; end
  module Unordered; end

  module CoreExtensions
    def json_ordered?
      self.is_a? Ordered
    end

    def json_unordered?
      self.is_a? Unordered
    end

    def json_ordered
      self.clone.json_ordered!
    end

    def json_unordered
      self.clone.json_unordered!
    end

    def json_ordered!
      if self.json_unordered?
        raise "cannot mark an unordered #{self.class} as ordered!"
      else
        self.extend Ordered
      end
    end

    def json_unordered!
      if self.json_ordered?
        raise "cannot mark an ordered #{self.class} as unordered!"
      else
        self.extend Unordered
      end
    end

    def json_strict?
      self.is_a? Strict
    end

    def json_forgiving?
      self.is_a? Forgiving
    end

    def json_strict
      self.clone.json_strict!
    end

    def json_forgiving
      self.clone.json_forgiving!
    end

    def json_strict!
      if self.json_forgiving?
        raise "cannot mark a forgiving #{self.class} as strict!"
      else
        self.extend Strict
      end
    end

    def json_forgiving!
      if self.json_strict?
        raise "cannot mark a strict #{self.class} as forgiving!"
      else
        self.extend Forgiving
      end
    end
  end
end

class Hash
  include JsonExpressions::CoreExtensions
  alias_method :json_reject_extra_keys, :json_strict
  alias_method :json_reject_extra_keys!, :json_strict!
  alias_method :json_ignore_extra_keys, :json_forgiving
  alias_method :json_ignore_extra_keys!, :json_forgiving!
end

class Array
  include JsonExpressions::CoreExtensions
  alias_method :json_reject_extra_values, :json_strict
  alias_method :json_reject_extra_values!, :json_strict!
  alias_method :json_ignore_extra_values, :json_forgiving
  alias_method :json_ignore_extra_values!, :json_forgiving!
end
