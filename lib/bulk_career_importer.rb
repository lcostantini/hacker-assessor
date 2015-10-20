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

  def build_requirements skill, requirements
    career.requirements.destroy_all
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
