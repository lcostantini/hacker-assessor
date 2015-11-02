class Experience
  include Comparable

  LEVELS = %w[ none novice beginner competent proficient expert authority ]

  attr_reader :skill_id, :level, :skill, :level_id

  def initialize skill, level
    self.skill = skill
    self.level = level
  end

  def <=> other
    return nil unless skill == other.skill
    LEVELS.find_index(level) <=> LEVELS.find_index(other.level)
  end

  def inspect
    "#<Experience: skill=#{ skill.name } level=#{ level }>"
  end

  def difference other
    return nil unless skill == other.skill
    level_id - other.level_id
  end
  alias_method :-, :difference

  private

  def skill= id_or_model
    id = if id_or_model.kind_of? Skill
           id_or_model.id
         else
           id_or_model
         end
    @skill = Skill.find id
    @skill_id = @skill.id
  end

  def level= number_or_name
    if number_or_name.respond_to? :downcase
      level_number = LEVELS.find_index number_or_name.downcase
    end
    @level_id = level_number || number_or_name || 0
    @level = LEVELS.fetch @level_id
  end

end
