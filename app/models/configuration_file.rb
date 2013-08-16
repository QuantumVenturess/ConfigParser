class ConfigurationFile < ActiveRecord::Base

  validates :name, presence: true
  validates_uniqueness_of :name
  
  has_many :parameters, dependent: :destroy

  before_save :slugify

  def absolute_file_path
    directory_name = "#{Rails.root}/public/files"
    File.join(directory_name, self.name)
  end

  def amazon_aws_url
    "http://s3.amazonaws.com/configparser/#{self.name}"
  end

  def self.delete_files
    # Delete file from web server
    directory_name = "#{Rails.root}/public/files"
    file_names     = Dir.entries(directory_name)
    file_names.each do |name|
      if name[/^[\w]+/]
        File.delete(File.join('public/files', name))
      end
    end
  end

  def save_parameters_from_file file
    path = self.absolute_file_path
    # Save file to web server
    File.open(path, 'wb') do |f|
      f.write(file.read)
    end
    new_file = File.open(path)
    # Save each parameter
    new_file.each_line do |line|
      if !line[/^#/] and line.split('=').count >= 2
        p_name, p_value = line.split('=')
        p_name  = p_name.strip
        p_value = p_value.strip
        p = self.parameters.find_by_name(p_name)
        if !p
          p = Parameter.new
          p.name = p_name
          p.configuration_file_id = self.id
        end
        p.value = p_value
        p.save
      end
    end
    new_file.close # Close file to allow deletion
    # Upload to Amazon S3
    s3 = AWS::S3.new(
      access_key_id:     ENV['AMAZON_AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AMAZON_AWS_SECRET_ACCESS_KEY']
    )
    bucket = s3.buckets['configparser']
    object = bucket.objects["#{self.name}"]
    object.write(Pathname.new(path))
    object.acl = :public_read
    ConfigurationFile.delete_files
  end

  def slugify
    self.slug = self.name.parameterize
  end

  def to_param
    self.slug
  end

end
