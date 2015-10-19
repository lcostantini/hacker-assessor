require 'csv'

class BulkCareerImporter

  def initialize name, requirements
    Career.transaction do
      @career = Career.find_or_create_by! name: name.underscore
      CSV.parse(requirements) do |skill, *requirements_for_skill|
        build_requirements skill, requirements_for_skill
      end
    end
  rescue ActiveRecord::RecordInvalid
  end

  def build_requirements skill, requirements
    skill = Skill.find_by name: skill
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
