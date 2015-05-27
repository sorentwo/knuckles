class ScoutSerializer < Knuckles::Serializer
  root :scout

  attributes :id,
             :first_name,
             :gender,
             :city,
             :state,
             :country,
             :education,
             :employment_status,
             :ethnicity,
             :household_composition,
             :household_income,
             :industry,
             :created_at,
             :updated_at
end

class ResponseSerializer < Knuckles::Serializer
  root :response

  attributes :id,
             :answers,
             :question_id,
             :respondable_id,
             :longitude,
             :latitude,
             :time_zone,
             :answered_at,
             :created_at,
             :updated_at
end

class TagSerializer < Knuckles::Serializer
  attributes :id,
             :parent_id,
             :name,
             :group,
             :auto_tag,
             :keywords,
             :created_at,
             :updated_at
end

class SubmissionSerializer < Knuckles::Serializer
  root = :submission

  attributes :id,
             :screener_id,
             :rating,
             :latitude,
             :longitude,
             :source,
             :time_zone,
             :bookmarks_count,
             :notes_count,
             :finished_at,
             :created_at,
             :updated_at

  has_one  :scout,     serializer: ScoutSerializer
  has_many :responses, serializer: ResponseSerializer
  has_many :tags,      serializer: TagSerializer
end
