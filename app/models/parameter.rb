class Parameter < ActiveRecord::Base

  validates :name, presence: true
  validates :configuration_file_id, presence: true
  validates :value, presence: true
  validates_uniqueness_of :name, on: :create

  belongs_to :configuration_file

  before_save :convert_boolean_value

  default_scope order: 'name ASC'

  def convert_boolean_value
    false_value = self.value[/^(false|no|off)$/i]
    true_value  = self.value[/^(on|true|yes)$/i]
    if false_value
      self.value = 'false'
    elsif true_value
      self.value = 'true'
    end
  end

  def type
    if self.value[/^(false|true)$/i]
      'Boolean'
    elsif self.value[/^[.\d]+$/]
      'Integer'
    else
      'String'
    end
  end

end
