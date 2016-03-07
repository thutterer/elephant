require 'yaml'

module Brain

  BRAIN = './brain.yml'

  def self.learn(key, values)
    memories = self.memories
    memories[key] = values
    File.write(BRAIN, memories.to_yaml)
  end

  def self.memories
    YAML.load_file(BRAIN) rescue Hash.new
  end

end

