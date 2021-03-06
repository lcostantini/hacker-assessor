class DefaultFormBuilder < ActionView::Helpers::FormBuilder
  def experience_level_select attribute = :level
    select attribute, Experience::LEVELS,
      selected: object.public_send(attribute).to_i
  end

  def skill_select attribute = :skill_id
    collection_select attribute, Skill.all, :id, :name, prompt: true
  end

  def seniority_select attribute = :seniority
    select attribute, Seniority.options,
      selected: object.public_send(attribute).to_i
  end
end

ActionView::Base.default_form_builder = DefaultFormBuilder
