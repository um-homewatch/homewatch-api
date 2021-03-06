# This class represents the triggered task model, a task that is applied on a specific
# value change from another thing
class Tasks::TriggeredTask < ApplicationRecord
  include Task
  belongs_to :thing_to_compare, class_name: "Thing"
  validates :status_to_compare, :thing_to_compare, presence: true

  validate :status_to_compare_params_equals_thing_params
  validate :status_to_apply_params_equals_thing_params
  validate :thing_to_compare_must_belong_to_home

  before_validation :trim_comparator

  def status
    status_to_apply
  end

  def status_to_compare
    self[:status_to_compare].symbolize_keys if self[:status_to_compare]
  end

  def apply_if
    comparison = thing_to_compare.compare(comparator, status_to_compare)

    if comparison && should_apply?
      apply
      update_attribute(:should_apply?, false)
    elsif !comparison
      update_attribute(:should_apply?, true)
    end
  end

  private

  def status_to_compare_params_equals_thing_params
    return if thing_to_compare && status_to_compare && (status_to_compare.keys - thing_to_compare.returned_params).empty?

    errors.add(:status_to_compare, "not a valid status for this thing type")
  end

  def thing_to_compare_must_belong_to_home
    return if home && thing_to_compare && home == thing_to_compare.home

    errors.add(:thing_to_compare_id, "thing must belong to home")
  end

  def trim_comparator
    comparator.strip! if comparator
  end
end
