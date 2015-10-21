require 'csv'
require 'forwardable'

class BulkCareerImporter

  include ActiveRecord::Validations
  extend Forwardable

  attr_accessor :career
  def_delegators :career, :to_model, :to_param, :to_key, :name, :description

  def initialize name, requirements, description=nil
    Career.transaction do
      build_career name
      career.description = description if description
      career.requirements.destroy_all
      CSV.parse(requirements) do |skill, *requirements_for_skill|
        build_requirements find_skill(skill), requirements_for_skill
      end
    end
  end

  private

  def find_skill skill_name
    Skill.find_by! 'lower(name) = ?', skill_name.downcase
  rescue ActiveRecord::RecordNotFound
    errors.add :requirements, "includes non existing skill \"#{ skill_name }\""
    raise ActiveRecord::Rollback, 'invalid skill'
  end

  # skill is an Skill object that already exists in the DB.
  # requirements is an array that represents the level for each Seniority.
  # i.e.
  # requirements = ["2", "2", "2", "2", "3", "3", "3", "3", "3", "3"]
  # The index of the requirements match with the index of the array
  # in Seniority::NAMES because the index of the requirements match
  # with the columns in the csv.
  # Then the number in the requirements match with a level for each skill
  # and each seniority.
  def build_requirements skill, requirements
    requirements.zip(Seniority::NAMES)
      .chunk{ |v, s| v.to_i unless v.nil? }
      .map do |exp, seniorities|
        seniority = Seniority::NAMES.index seniorities.first.last
        career.requirements.create! seniority: seniority,
                                     level: exp,
                                     skill: skill
    end
  end

  def build_career name
    self.career = Career.find_or_create_by name: name.underscore
    if career.invalid?
      errors.add :name, career.errors[:name].first
      raise(ActiveRecord::Rollback, 'lacking name')
    end
  end

end
