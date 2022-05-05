class CLI
  def usage
    <<-USAGE
    usage: pdq SUBCOMMAND [ARGS] FILE

    subcommands:
      list            lists the sections available for querying in FILE
      read NAME       prints the contents of the section NAME in FILE
      append NAME     appends STDIN to the section NAME of the FILE

    USAGE
  end

  def main
    case ARGV.shift?
    when "version" then version()
    when "help"    then help()
    when "list"    then list()
    when "read"    then read()
    when "append"  then append()
    else                nothing()
    end
  end

  def nothing
    STDERR.puts usage
    exit 1
  end

  def help
    puts usage
    exit 0
  end

  def version
    puts "pdq v0.0.0"
  end

  def list
    unless filename = ARGV.shift?
      STDERR.puts "usage: list FILENAME"
      exit 1
    end

    File.open(filename) do |file|
      while line = file.gets
        if name = line.match(/\[\[(.+)\]\]/).try &.[1]?.try &.strip
          puts name
        end
      end
    end
  end

  def read
    unless section_name = ARGV.shift?
      STDERR.puts "usage: read SECTION FILENAME"

      STDERR.puts "missing SECTION"
      exit 1
    end

    unless filename = ARGV.shift?
      STDERR.puts "usage: read SECTION FILENAME"

      STDERR.puts "missing FILENAME"
      exit 1
    end

    File.open(filename) do |file|
      looking_at = ""
      while line = file.gets
        if name = line.match(/\[\[(.+)\]\]/).try &.[1]?.try &.strip
          looking_at = name
        else
          if looking_at == section_name
            STDOUT.puts line
          end
        end
      end
    end
  end

  macro method_missing(call)
    {% puts("warning: #{call.name.stringify} is not implemented yet") %}
    def {{call.name}}
      STDERR.puts "pdq #{{{call.name.stringify}}} is not implemented yet"
      exit 1
    end
  end
end

CLI.new.main
