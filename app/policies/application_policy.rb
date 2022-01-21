class ApplicationPolicy
  class Scope
    attr_reader :contest, :scope

    def initialize contest, scope
      @contest, @scope = contest, scope
    end
  end

  attr_reader :contest, :resource

  delegate_missing_to :contest, allow_nil: true

  def initialize contest, resource
    @contest, @resource = contest, resource
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
