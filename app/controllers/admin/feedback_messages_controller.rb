module Admin
  class FeedbackMessagesController < BaseController
    def index
      @messages = FeedbackMessage.recent
    end

    def update
      FeedbackMessage.find(params[:id]).update!(status: "answered")
      redirect_to admin_feedback_messages_path, notice: "Позначено як оброблене"
    end
  end
end
