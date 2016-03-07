require 'open3'

module Zypper

  def Zypper.install(package)
    output, status = Zypper.run("install #{package}")
    return nil unless status.success?
    line = output.index { |l| l =~ /The following \d* ?NEW packages? (is|are) going to be installed:/}
    if line
      packages = output[line.next].split
      Brain.learn(
        {
          wanted: package,
          installed: packages,
          time: Time.now
        }
      )
      return packages
    else
      return nil
    end
  end

  def Zypper.list
    Brain.memories.each do |b|
      puts b[:wanted]
    end
  end

  def Zypper.run(cmd)
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



