require 'spec_helper'

describe ConfigurationFile do
  let(:config_file) { ConfigurationFile.new }
  subject { config_file }

  it 'should not save without a name' do
    expect { config_file.save! }.to raise_error(
      ActiveRecord::RecordInvalid
    )
  end

  it 'should have a unique name' do
    config_file.name = 'test'
    config_file.save
    new_config_file = ConfigurationFile.new
    new_config_file.name = 'test'
    expect { new_config_file.save }.to_not change { 
      ConfigurationFile.count }.by(1)
  end

  it 'should save and be valid' do
    config_file.name = 'test'
    config_file.save
    config_file.should be_valid
  end

end