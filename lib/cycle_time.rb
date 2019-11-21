require 'byebug'
require 'ap'
require 'date'
require 'active_support'
require 'active_support/core_ext'
require 'csv'

class CycleTime
  ANALYSIS_STATUS_ID = '4'.freeze
  READY_TO_WORK_STATUS_ID = '10'.freeze
  IN_PROGRESS_STATUS_ID = '3'.freeze
  TEST_STATUS_ID = '11'.freeze
  FEEDBACK_STATUS_ID = '5'.freeze
  DONE_STATUS_ID = '9'.freeze

  def self.parse(issue_detail)
    issue_detail.deep_symbolize_keys!
    {
      id: issue_detail[:id],
      subject: issue_detail[:subject],
      analysis: analysis(issue_detail[:journals]),
      ready_to_work: ready_to_work(issue_detail[:journals]),
      in_progress: in_progress(issue_detail[:journals]),
      test: test(issue_detail[:journals]),
      feedback: feedback(issue_detail[:journals]),
      done: done(issue_detail[:journals])
    }
  end

  def self.analysis(journals)
    thing journals, ANALYSIS_STATUS_ID
  end

  def self.in_progress(journals)
    thing journals, IN_PROGRESS_STATUS_ID
  end

  def self.ready_to_work(journals)
    thing journals, READY_TO_WORK_STATUS_ID
  end

  def self.test(journals)
    thing journals, TEST_STATUS_ID
  end

  def self.feedback(journals)
    thing journals, FEEDBACK_STATUS_ID
  end

  def self.done(journals)
    thing journals, DONE_STATUS_ID
  end

  def self.thing(journals, datum)
    status_change = journals.select do |journal|
      journal[:details].any? do |detail|
        detail[:name] == 'status_id' && detail[:new_value] == datum
      end
    end
    status_change.first[:created_on] if status_change.any?
  end
end