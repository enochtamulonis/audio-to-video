class ConversionsController < ApplicationController
  def create
    @conversion = Conversion.new(conversion_params)
    @conversion.guest_user_id = @current_guest_user
    if @conversion.save
      AudioToVideoJob.perform_later(@conversion)
      render turbo_stream: turbo_stream.update("audio-to-video", partial: "conversions/loading", locals: { conversion: @conversion })
    else
      render turbo_stream: turbo_stream.update("conversion-form", partial: "form", locals: { conversion: @conversion })
    end
  end

  private

  def conversion_params
    params.require(:conversion).permit(:audio, :image)
  end
end