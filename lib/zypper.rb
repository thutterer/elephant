require 'open3'

module Zypper

  def self.install(package)
    output, status = Zypper.run("install #{package}")
    return nil unless status.success?
    line = output.index { |l| l =~ /The following \d* ?NEW packages? (is|are) going to be installed:/}
    if line
      packages = output[line.next].split
      Brain.learn(package,
        {
          packages: packages,
          time: Time.now
        }
      )
      return packages
    else
      return nil
    end
  end

  def self.list
    Brain.memories.keys.each do |package|
      puts package
    end
  end

  def self.remove(package)
    self.run("remove #{Brain.memories[package][:packages].join(' ')}")
  end

  def self.run(cmd)
    output = []
    status = nil
    Open3.popen3("sudo zypper #{cmd}") do |stdin, stdout, stderr, wait_thr|
      out_line = ''
      while char = stdout.getc
        print char
        unless char == "\n"
          out_line += char
        else
          output.push out_line
          out_line = ''
        end
      end
      while err_line = stderr.gets
        puts err_line
      end
      status = wait_thr.value
    end
    return output, status
  end

end



