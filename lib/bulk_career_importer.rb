require 'csv'

class BulkCareerImporter

  include ActiveRecord::Validations

  def initialize name, requirements
    Career.transaction do
      @career = Career.find_or_create_by! name: name.underscore
      CSV.parse(requirements) do |skill, *requirements_for_skill|
        build_requirements find_skill(skill), requirements_for_skill
      end
    end
  end

  private

  def find_skill skill_name
    Skill.find_by! name: skill_name
  rescue ActiveRecord::RecordNotFound
    errors.add :requirements, "includes non existing skill \"#{ skill_name }\""
    raise ActiveRecord::Rollback, 'invalid skill'
  end

  def build_requirements skill, requirements
    @career.requirements.where(skill: skill).destroy_all
    requirements.zip(Seniority::NAMES)
      .chunk{ |v, s| v.to_i }
      .map do |exp, seniorities|
        seniority = Seniority::NAMES.index seniorities.first.last
        @career.requirements.create! seniority: seniority,
                                     level: exp,
                                     skill: skill
    end
  end


end
