module ScoutView
  extend Knuckles::View

  def self.root
    :scouts
  end

  def self.data(object, _)
    { id: object.id,
      first_name: object.first_name,
      gender: object.gender,
      city: object.city,
      state: object.state,
      country: object.country,
      education: object.education,
      employment_status: object.employment_status,
      ethnicity: object.ethnicity,
      household_composition: object.household_composition,
      household_income: object.household_income,
      industry: object.industry,
      created_at: object.created_at,
      updated_at: object.updated_at }
  end
end

module ResponseView
  extend Knuckles::View

  def self.root
    :responses
  end

  def self.data(object, _)
    { id: object.id,
      answers: object.answers,
      question_id: object.question_id,
      respondable_id: object.respondable_id,
      longitude: object.longitude,
      latitude: object.latitude,
      time_zone: object.time_zone,
      answered_at: object.answered_at,
      created_at: object.created_at,
      updated_at: object.updated_at }
  end
end

module TagView
  extend Knuckles::View

  def self.root
    :tags
  end

  def self.data(object, _)
    { id: object.id,
      parent_id: object.parent_id,
      name: object.name,
      group: object.group,
      auto_tag: object.auto_tag,
      keywords: object.keywords,
      created_at: object.created_at,
      updated_at: object.updated_at }
  end
end

module SubmissionView
  extend Knuckles::View

  def self.root
    :submissions
  end

  def self.data(object, _)
    { id: object.id,
      screener_id: object.screener_id,
      rating: object.rating,
      latitude: object.latitude,
      longitude: object.longitude,
      source: object.source,
      time_zone: object.time_zone,
      bookmarks_count: object.bookmarks_count,
      notes_count: object.notes_count,
      finished_at: object.finished_at,
      created_at: object.created_at,
      updated_at: object.updated_at }
  end

  def self.relations(object, _)
    { scouts: [has_one(object.scout, ScoutView)],
      responses: has_many(object.responses, ResponseView),
      tags: has_many(object.tags, TagView) }
  end
end
