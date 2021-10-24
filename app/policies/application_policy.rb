class ApplicationPolicy
  class Scope
    attr_reader :context, :scope

    delegate_missing_to :context, allow_nil: true

    def initialize context, scope
      @context, @scope = context, scope
    end
  end

  attr_reader :context, :resource

  delegate_missing_to :context, allow_nil: true

  def initialize context, resource
    @context, @resource = context, resource
  end

  def index?
    false
  end

  def show?
    false
  end

  def new?
    false
  end

  def create?
    false
  end

  def edit?
    false
  end

  def update?
    false
  end

  def destroy?
    false
  end
end
