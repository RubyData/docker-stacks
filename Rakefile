OWNER = 'rubydata'.freeze
ALL_IMAGES = %w[
  minimal
  datascience
].each(&:freeze).freeze

BASE_IMAGES = ALL_IMAGES.map { |name|
  base_image_name, base_image_tag = nil
  IO.foreach("#{name}/Dockerfile") do |line|
    break if base_image_name && base_image_tag
    case line
    when /BASE_IMAGE_TAG=(\h+)/
      base_image_tag = $1
    when /\AFROM\s+([^:]+)/
      base_image_name = $1
    end
  end
  [
    name,
    [base_image_name, base_image_tag].join(":")
  ]
}.to_h

DOCKER_FLAGS = ENV['DOCKER_FLAGS']

ALL_IMAGES.each do |image|
  desc "Pull the base image for #{OWNER}/#{image} image"
  task "pull/base_image/#{image}" do
    base_image = BASE_IMAGES[image]
    sh "docker pull #{base_image}"
  end

  desc "Build #{OWNER}/#{image} image"
  task "build/#{image}" => "pull/base_image/#{image}" do
    sh "docker build #{DOCKER_FLAGS} --rm --force-rm -t #{OWNER}/#{image}:latest ./#{image}"
  end

  desc "Push #{OWNER}/#{image} image"
  task "push/#{image}" do
    sh "docker push #{OWNER}/#{image}:latest"
  end
end


desc "Build all images"
task "build-all" do
  ALL_IMAGES.each do |image|
    Rake::Task["build/#{image}"].invoke
  end
end


desc "Push all images"
task "push-all" do
  ALL_IMAGES.each do |image|
    Rake::Task["push/#{image}"].invoke
  end
end
