class AudioToVideoJob < ApplicationJob
  include Rails.application.routes.url_helpers
  include ActionView::RecordIdentifier
  queue_as :default

  def perform(conversion)
    puts "###-----####--- Starting process"
    file_path = AudioToVideo.audio_to_video(conversion.audio, image: conversion.image)
    File.open(file_path) do |local_file|
      conversion.video.attach(io: local_file, filename: "final.mp4")
    end
    File.delete(file_path)
    conversion.broadcast_update_to(conversion, target: "audio-to-video", 
      partial: "conversions/success", locals: { conversion: conversion } )
  end
end
