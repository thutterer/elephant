require 'yaml'

module Brain

  BRAIN = './brain.yml'

  def Brain.learn(info)
    brain = YAML.load_file(BRAIN) rescue Array.new
    brain.push info
    File.write(BRAIN, brain.to_yaml)
  end

end

