# frozen_string_literal: true

class Eslint
  class << self
    def check(dest)
      command = "npx eslint -f json -c lib/linter_configs/.eslintrc.yml #{dest}"
      output, status = Open3.popen3(command) do |_, stdout, _, thread|
        parsed = JSON.parse(stdout.read)
        [parsed, thread.value]
      end

      [serialize(output, dest), status]
    end

    def serialize(data, repo_path)
      data.each_with_object([]) do |info, result|
        file_path = Pathname.new(info['filePath']).relative_path_from(repo_path).to_s
        info['messages'].each do |mes|
          result << {
            message: mes['message'],
            rule: mes['ruleId'],
            line: mes['line'],
            column: mes['column'],
            file_path: file_path
          }
        end
      end
    end
  end
end
