# frozen_string_literal: true

class Rubocop
  class << self
    def check(dest)
      command = "bundle exec rubocop -f json -c .rubocop.yml #{dest}"
      output, status = Open3.popen3(command) do |_, stdout, _, thread|
        parsed = JSON.parse(stdout.read)
        [parsed['files'], thread.value]
      end

      [serialize(output, dest), status]
    end

    def serialize(data, repo_path)
      data.each_with_object([]) do |info, result|
        file_path = Pathname.new(info['path'])
        file_path = file_path.relative_path_from(repo_path) if file_path.absolute?

        info['offenses'].each do |offense|
          result << {
            message: offense['message'],
            rule: offense['cop_name'],
            line: offense['location']['start_line'],
            column: offense['location']['start_column'],
            file_path: file_path.to_s
          }
        end
      end
    end
  end
end
