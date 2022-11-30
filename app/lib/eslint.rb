# frozen_string_literal: true

class Eslint
  class << self
    def check(dest)
      command = "yarn run eslint -f json -c .eslintrc.yml #{dest}"
      output, status = Open3.popen3(command) do |_, stdout, _, thread|
        [stdout.to_a[2], thread.value]
      end

      [parse(output, dest), status]
    end

    def parse(str, repo_path)
      JSON.parse(str).each_with_object([]) do |info, result|
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
