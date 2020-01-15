module ScoresHelper

  def set_score_as score
    session[:score_id] = score.id
    current_score = score
  end

  def unset_score
    session.delete(:score_id)
    current_score = nil
  end

  def current_score
    if ( score_id = session[:score_id] )
      begin
        @current_score ||= Score.find(score_id)
      rescue
        flash.now[:error] = "There was a problem retrieving your score."
        session.delete(:score_id)
        return nil
      end
    else
      nil
    end
  end

  def current_score=(score)
    @current_score = score
  end

  def score_set?
    !current_score.nil?
  end

  def score_set_as? score
    current_score == score
  end

  def pending_score?
    score_set? && current_score.active?
  end

  def formatted_duration seconds
    if seconds >= (60 * 60)
      format("%02dh : %02dm : %02ds", (seconds / (60 * 60)), ((seconds / 60) % 60), (seconds % 60))
    elsif seconds >= 60
      format("%02dm : %02ds", ((seconds / 60) % 60), (seconds % 60))
    else
      format("%02ds", (seconds))
    end
  end

end
