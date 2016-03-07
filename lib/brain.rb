require 'yaml'

module Brain

  BRAIN = './brain.yml'

  def self.learn(info)
    memories = self.memories
    memories.push info
    File.write(BRAIN, memories.to_yaml)
  end

  def self.memories
    YAML.load_file(BRAIN) rescue Array.new
  end

end

