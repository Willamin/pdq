class CLI
  def usage
    <<-USAGE
    usage: pdq SUBCOMMAND [ARGS] FILE

    subcommands:
      version             prints pdq's version
      help                prints this help
      description NAME    prints the description section in FILE
      list                lists the sections available for querying in FILE
      read NAME           prints the contents of the section NAME in FILE
      append NAME [OPT]   appends STDIN to the section NAME of the FILE
      run [NAME]          executes the section NAME as if it were a script    *
                              if NAME is not provided, "Script" is used       *
                              if section NAME is not found, pqd returns 1     *

    append options:
      -f, --force         add a new section at the end if it was not found    *
      -n, --no-newline    avoid a blank line between sections                 *


    * Feature is not implemented yet.

    USAGE
  end

  def main
    case ARGV.shift?
    when "version"     then version()
    when "help"        then help()
    when "description" then description()
    when "list"        then list()
    when "read"        then read()
    when "append"      then append()
    when "run"         then run()
    else                    nothing()
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

  def description
    unless filename = ARGV.shift?
      STDERR.puts "usage: description FILENAME"
      exit 1
    end

    File.open(filename) do |file|
      while line = file.gets
        if name = line.match(/\[\[(.+)\]\]/).try &.[1]?.try &.strip
          break
        else
          puts line
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

  def append
    unless section_name = ARGV.shift?
      STDERR.puts "usage: append SECTION FILENAME"

      STDERR.puts "missing SECTION"
      exit 1
    end

    unless filename = ARGV.shift?
      STDERR.puts "usage: append SECTION FILENAME"

      STDERR.puts "missing FILENAME"
      exit 1
    end

    end_of_section_line_index : Int32? = nil
    found_match = false

    File.open(filename) do |file|
      looking_at = ""
      iterator = 0
      while line = file.gets
        iterator += 1
        if name = line.match(/\[\[(.+)\]\]/).try &.[1]?.try &.strip
          if found_match
            end_of_section_line_index = iterator - 1
            break
          else
            if name == section_name
              found_match = true
            end
          end
        end
      end
      if end_of_section_line_index.nil? && found_match
        end_of_section_line_index = iterator + 1
      end
    end

    if end_of_section_line_index.nil?
      STDERR.puts "missing section '#{section_name}'"
      exit 1
    end

    inserted = false
    File.tempfile do |tempfile|
      tempfile = tempfile.path
      File.copy(filename, tempfile)
      File.open(filename, "w") do |destination|
        File.open(tempfile) do |source|
          iterator = 0
          while line = source.gets
            iterator += 1
            if iterator == end_of_section_line_index
              inserted = true
              while new_line = STDIN.gets
                destination.puts(new_line)
              end
            end
            destination.puts(line)
          end
          if !inserted
            while new_line = STDIN.gets
              destination.puts(new_line)
            end
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
