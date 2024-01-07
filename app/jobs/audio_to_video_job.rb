class AudioToVideoJob < ApplicationJob
  include Rails.application.routes.url_helpers
  include ActionView::RecordIdentifier
  queue_as :default

  def perform(conversion)
    puts "###-----####--- Starting process"
    audio = conversion.audio
    image = conversion.image
    loop_option = if image.blob.content_type.downcase.include?("gif")
      "-ignore_loop 0" 
    else
      "-loop 1"
    end

    movie_path = Rails.root.join("tmp/audio_#{Time.zone.now.strftime("%s_%m_video")}.mp4")

    audio.open do |local_audio|
      image.open do |local_image|
        command = "ffmpeg #{loop_option} -i #{local_image.path} -i #{local_audio.path} -c:v libx264 -tune stillimage -c:a aac -strict experimental -b:a 192k -shortest #{movie_path}"
        system(command)
      end
    end
    File.open(movie_path) do |local_file|
      conversion.video.attach(io: local_file, filename: "final.mp4")
    end
    File.delete(movie_path)
    conversion.broadcast_update_to(conversion, target: "audio-to-video", 
      partial: "conversions/success", locals: { conversion: conversion } )
  end
end
