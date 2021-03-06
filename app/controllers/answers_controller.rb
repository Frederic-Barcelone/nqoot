class AnswersController < ApplicationController
  
  # Method called to create a new answer. Params
  # is passed to add_answer in the Answer model
  # including the uid of the current user.
  def create
    if current_user
      Answer.add_answer(params, current_user.uid)
    end
  end
  
  # Given an id of an answer, deletes the answer
  # from the database. Only delete the answer
  # iff the current user owns the answer.
  def delete
    answer = Answer.find_by_id(params[:id])
    if answer.user_id == current_user.uid
      answer.destroy
      render :nothing => true
    end
  end
  
  # Given an id of an answer, adds one vote to
  # the specific answer. Only allow upvote if
  # user has not upvoted an answer.
  def up_vote
    if current_user
      answer_id = params[:answer_id]
      can_vote = Vote.can_vote(answer_id, current_user.uid)
      if can_vote
        answer = Answer.find_by_id(answer_id)
        answer.vote += 1
        answer.save!
        
        Vote.add_vote(answer_id, current_user.uid)
      end
    end
    render :nothing => true
  end
  
  # Given an id of answer, deducts one vote from
  # the specific answer. Only allow downvote if
  # user already upvoted the answer.
  def down_vote
    if current_user
      answer_id = params[:answer_id]
      can_vote = Vote.can_vote(answer_id, current_user.uid)
      if not can_vote
        answer = Answer.find_by_id(answer_id)
        answer.vote -= 1
        answer.save!
        
        Vote.delete_vote(answer_id, current_user.uid)
      end
    end
  end
  
  # Sets is_staff_endorsed to true to an answer
  # given an answer_id.
  def endorse
    if current_user.is_staff
      answer = Answer.find_by_id(params[:answer_id])
      answer.is_staff_endorsed = true
      answer.save!
    end
    render :nothing => true
  end
  
  # Sets is_staff_endorsed to false to an answer
  # given an answer_id.
  def unendorse
    if current_user.is_staff
      answer = Answer.find_by_id(params[:answer_id])
      answer.is_staff_endorsed = false
      answer.save!
    end
    render :nothing => true
  end

  # Function called to render all answers to a answers
  # given an answer_id. Ordered by descending votes.  
  def show
    if current_user
      @question = Question.find_by_id(params[:question_id])
      if @question    
        @answers = Answer.where(:question_id => @question.id).order('vote DESC').all
        render :layout => false
      else
        render :nothing => true
      end
    else
      render :nothing => true
    end
  end
  
end
