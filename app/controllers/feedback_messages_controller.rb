class FeedbackMessagesController < ApplicationController
  def new
    @feedback = FeedbackMessage.new(name: current_user&.name, email: current_user&.email)
  end

  def create
    @feedback = FeedbackMessage.new(feedback_params.merge(user: current_user))
    if @feedback.save
      redirect_to contacts_path, notice: "Повідомлення надіслано. Ми відповімо протягом робочого дня."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def feedback_params
    params.require(:feedback_message).permit(:name, :email, :subject, :body)
  end
end
