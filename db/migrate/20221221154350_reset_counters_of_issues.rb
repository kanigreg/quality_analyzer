class ResetCountersOfIssues < ActiveRecord::Migration[7.0]
  def up
    Repository::Check.find_each do |check|
      Repository::Check.reset_counters(check.id, :issues)
    end
  end
end
