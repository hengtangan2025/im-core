class Admin::QuestionsController < ApplicationController
  def index
    @component_name = "QuestionIndexPage"
    @component_data = {
      single_new_url: new_admin_question_path,
      multi_new_url: multi_new_admin_questions_path,
      bool_new_url: bool_new_admin_questions_path,
    }
  end

  def new 
    @component_name = "SingleEditPage"
    @component_data = {
      cancel_url: admin_questions_path,
    }
  end

  def multi_new
    @component_name = "MultiEditPage"
    @component_data = {
      cancel_url: admin_questions_path,
    }
  end

  def bool_new
    @component_name = "BoolEditPage"
    @component_data = {
      cancel_url: admin_questions_path,
    }
  end
end